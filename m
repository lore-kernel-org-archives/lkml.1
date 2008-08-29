Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYH2JFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYH2JFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 05:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYH2JFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 05:05:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:48844 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbYH2JFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 05:05:23 -0400
Message-ID: <48B7BB4C.4060907@kernel.org>
Date: Fri, 29 Aug 2008 11:03:08 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>, Eric Biederman <ebiederm@xmission.com>,
       Serge Hallyn <serue@us.ibm.com>
CC: greg@kroah.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org> <48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu> <48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu> <48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu> <48B6FFB6.7000104@kernel.org> <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu> <48B75C94.7030604@kernel.org> <E1KYyt9-0005Ur-Eu@pomaz-ex.szeredi.hu> <48B7AF60.8040709@kernel.org> <E1KYzMd-0005aR-28@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KYzMd-0005aR-28@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 09:04:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Fri, 29 Aug 2008, Tejun Heo wrote:
>> I first used 'server' for userland [FC]USE server but then I noticed
>> there were places in FUSE they were referred as clients so now I use
>> 'client' for those and call the app using the FUSE fs the 'caller'.
>> What are the established terms?
> 
> Umm
> 
>  - userspace filesystem
>  - filesystem daemon
>  - filesystem process
>  - server
> 
> Yes it's also a client of the fuse device, but that term is confusing.

Okay, will do s/client/server/g

>> Anyways, doing it directly from the server (or is it client) opens up a
>> lot of new possibilities to screw up and I'd really much prefer staying
>> in similar ballpark with other operations.  Maybe we can restrict it to
>> two stages (query size & transfer) and linear consecutive ranges but
>> then again adding retry doesn't contribute too much to the complexity.
>> Oh.. and BTW, the in-ioctl length coding is not used universally, so it
>> can't be depended upon.
> 
> I know it's not universal, some horrors I've seen in the old wireless
> interfaces.  The question is: do we want to support such "extended"
> ioctls?  For exmaple, does OSS have non-conformant ioctls?

OSS ioctls are all pretty simple and I think they all use the proper
encoding.  For the question, my answer would be yes (naturally).  It
will suck later when implementing some other device only to find out
that there's this one ioctl that needs to dereference a pointer but
there's no supported way to do it but everything else works.

I don't think the performance or the complexity of specific ioctl
implementation is of the determining importance as long as it can be
made to work with minimal impact on the rest of the whole thing, so
the current retry implementation.

>>>>  Also, what about containers?  How would it work then?
>>> Dunno.  Isn't there some transformation of pids going on, so that the
>>> global namespace can access pids in all containers but under a
>>> different alias?  I do hope somethinig like this works, otherwise it's
>>> not only fuse that will break.
>> I'm not sure either.  Any idea who we should be asking about it?
> 
> Serge Hallyn and Eric Biederman.

Okay, cc'd both.  Hello, Eric Biederman, Serge Hallyn.  For
implementing ioctl in FUSE, it's suggested that to access the address
space of the caller directly from the FUSE server using its pid via
/proc/pid/mem (or task/tid/mem).  It's most likely that the calling
process's tid will be used.  As I don't know much about the
containers, I'm not sure how such approach will play out when combined
with containers.  Can you enlighten us a bit?  W/o containers, it will
look like the following.


          FUSE ----------------
           ^                   |
           |                   |        kernel
  ------ ioctl ----------- /dev/fuse ------------
           |                   |       userland
           |                   v
    ---------------      -------------
   | caller        |    | FUSE server |---> reads and writes
   | with tid CTID |    |             |    /proc/PID/task/TID/mem
    ---------------      -------------

The FUSE server gets task->pid.  IIUC, if the FUSE server is not in a
container, task->pid should work fine whether the caller is in
container or not, right?  And if the FUSE server is in a container,
it's hell lot more complex and FUSE may have to map task->pid to what
FUSE server would know if possible?

Thanks.

-- 
tejun
