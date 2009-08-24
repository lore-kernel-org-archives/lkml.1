Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbZHXXSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbZHXXSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZHXXSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:18:08 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:36206 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbZHXXSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:18:06 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Aug 2009 19:18:05 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jC5Q1pa+4oUdmes/2E+Xo42kL2dsvFmusFuuzh+evaNnoyOJNkg2P8EzobJeB5SLax
         noi/+96JDAm0Migv/4Ad8yevQD8dt8CdRpesxChQIpX/y+gsxqSkrzgzf6mT0ONMC/TI
         lfvyQiw+qSkmur60/qiT3zw3azOXF1NZi8ty4=
MIME-Version: 1.0
In-Reply-To: <1251134769.6325.273.camel@heimdal.trondhjem.org>
References: <6278d2220908240818g3fc23311i607143b7cb6b965d@mail.gmail.com>
	 <1251134769.6325.273.camel@heimdal.trondhjem.org>
Date: Tue, 25 Aug 2009 00:12:38 +0100
Message-ID: <6278d2220908241612g32cf4e61l3bc80c3f8c9d4037@mail.gmail.com>
Subject: Re: [2.6.31-rc7] NFS4 client manager kthread spinning...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-nfs@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 6:26 PM, Trond
Myklebust<Trond.Myklebust@netapp.com> wrote:
> On Mon, 2009-08-24 at 16:18 +0100, Daniel J Blueman wrote:
>> Hi Trond,
>>
>> On Mon, Aug 17, 2009 at 2:53 PM, Daniel J
>> Blueman<daniel.blueman@gmail.com> wrote:
>> > Hi Trond,
>> >
>> > On Mon, Aug 17, 2009 at 2:12 PM, Trond
>> > Myklebust<Trond.Myklebust@netapp.com> wrote:
>> >> On Sun, 2009-08-16 at 23:40 +0100, Daniel J Blueman wrote:
>> >>> After losing and regaining ethernet link a few times with 2.6.31-rc5
>> >>> [1], I've hit an oops in the NFS4 client manager kthread [2] on my
>> >>> client with NFS4 homedir mount.
>> >>>
>> >>> Do you have a frequent test-case for when the client's manager kthread
>> >>> gets invoked (with and without succeeding callbacks, due to eg a
>> >>> firewall)? Server here is unpatched 2.6.30-rc6; I recall seeing
>> >>> problems when the manager kthread gets invoked, across quite a few
>> >>> kernel releases, just wasn't lucky enough to catch an oops.
>> >>>
>> >>> Oppsing in allow_signal() suggests task state corruption perhaps? I'm
>> >>> downloading the debug kernel to match up the disassembly and line
>> >>> numbers, if that helps? This time, the client had no firewall (but
>> >>> have seen other issues when the callback has failed due to the
>> >>> firewall).
>> >>
>> >> Those aren't Oopses. They are 'soft lockup' warnings. Basically, they're
>> >> saying that the CPU is getting stuck waiting for a spin lock or a mutex.
>> >>
>> >> In this case, it is probably the fact that the state manager is going
>> >> nuts trying to recover, while the connection to the server keeps coming
>> >> up and going down.
>> >>
>> >> What does 'netstat -t' say when you get into this situation?
>> >
>> > Whoops; it's true the stack-trace comes from the soft-lockup detector.
>> >
>> > There was a single 200s link excursion, but the client didn't recover
>> > as locks are held and never released it seems; I observe the
>> > '192.168.1.250-m' NFS4 manager kthread being created and not going
>> > away, despite IP connectivity with the server being fine after.
>> >
>> > I'll reproduce it with stock 2.6.31-rc6 on the client and get 'netstat
>> > -t' output.
>>
>> (subject line updated)
>>
>> After further analysis, I see that NFS services do correctly recover
>> after the link excursion, however we see:
>>  - link is restored
>>  - the manager kthread gets created, does some work
>>  - we see lock reclamation fail [1]
>>  - after a short while, NFS read()s continue, all is good
>>  - the manager kthread spins indefinitely [2, 3] on (struct
>> rpc_wait_queue)queue->lock with spin_lock_bh() [see rpc_wake_up]
>>
>> This seems reproducible with various kernel debugging enabled (perhaps
>> suggesting use-after-free via the lock being reinitialised/poisoned?).
>>
>> Let me know if anything else may help track this down (config, stack
>> frame resolution etc). I'll take a deeper look if I get time in a
>> couple of weeks, but alas it may be after 2.6.31 is released. NFS+RPC
>> debugging (taken at a different time than [1]) at
>> http://quora.org/hive/nfs-manager-spin.bz2 .
>
> I think I've found the bug. Does the following patch fix it for you?
>
> Cheers
>  Trond
> ----------------------------------------------------------------------
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> NFSv4: Fix an infinite looping problem with the nfs4_state_manager
>
> Commit 76db6d9500caeaa774a3e32a997eba30bbdc176b (nfs41: add session setup
> to the state manager) introduces an infinite loop possibility in the NFSv4
> state manager. By first checking nfs4_has_session() before clearing the
> NFS4CLNT_SESSION_SETUP flag, it allows for a situation where someone sets
> that flag, but it never gets cleared, and so the state manager loops.
>
> In fact commit c3fad1b1aaf850bf692642642ace7cd0d64af0a3 (nfs41: add session
> reset to state manager) causes this to happen every time we get a network
> partition error.
>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
>
>  fs/nfs/nfs4state.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
>
> diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
> index 65ca8c1..1434080 100644
> --- a/fs/nfs/nfs4state.c
> +++ b/fs/nfs/nfs4state.c
> @@ -1250,8 +1250,8 @@ static void nfs4_state_manager(struct nfs_client *clp)
>                                continue;
>                }
>                /* Initialize or reset the session */
> -               if (nfs4_has_session(clp) &&
> -                  test_and_clear_bit(NFS4CLNT_SESSION_SETUP, &clp->cl_state)) {
> +               if (test_and_clear_bit(NFS4CLNT_SESSION_SETUP, &clp->cl_state)
> +                  && nfs4_has_session(clp)) {
>                        if (clp->cl_cons_state == NFS_CS_SESSION_INITING)
>                                status = nfs4_initialize_session(clp);
>                        else
>

Yes, this addresses the manager kthread spinning; nice work!

Perhaps unrelated to the manager kthread, I reproduced a
"nfs4_reclaim_open_state: Lock reclaim failed!" message ultimately -
expected/significant?

Thanks,
  Daniel

---

Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>
-- 
Daniel J Blueman
