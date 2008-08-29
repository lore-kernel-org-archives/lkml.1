Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYH2TYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYH2TYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 15:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbYH2TY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 15:24:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59999 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYH2TY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 15:24:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Serge Hallyn <serue@us.ibm.com>,
       greg@kroah.com, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
	<1219945263-21074-6-git-send-email-tj@kernel.org>
	<20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org>
	<48B6E801.9080102@kernel.org> <E1KYm0D-0003q0-IQ@pomaz-ex.szeredi.hu>
	<48B6EBBD.6050406@kernel.org> <E1KYm9u-0003v5-4t@pomaz-ex.szeredi.hu>
	<48B6EF98.4070008@kernel.org> <E1KYn7T-00048J-Qj@pomaz-ex.szeredi.hu>
	<48B6FFB6.7000104@kernel.org> <E1KYnhA-0004Ei-3t@pomaz-ex.szeredi.hu>
	<48B75C94.7030604@kernel.org> <E1KYyt9-0005Ur-Eu@pomaz-ex.szeredi.hu>
	<48B7AF60.8040709@kernel.org> <E1KYzMd-0005aR-28@pomaz-ex.szeredi.hu>
	<48B7BB4C.4060907@kernel.org>
Date: Fri, 29 Aug 2008 12:17:12 -0700
In-Reply-To: <48B7BB4C.4060907@kernel.org> (Tejun Heo's message of "Fri, 29
	Aug 2008 11:03:08 +0200")
Message-ID: <m163pjr5qf.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2993]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Miklos Szeredi wrote:
>> On Fri, 29 Aug 2008, Tejun Heo wrote:
>>> I first used 'server' for userland [FC]USE server but then I noticed
>>> there were places in FUSE they were referred as clients so now I use
>>> 'client' for those and call the app using the FUSE fs the 'caller'.
>>> What are the established terms?
>> 
>> Umm
>> 
>>  - userspace filesystem
>>  - filesystem daemon
>>  - filesystem process
>>  - server
>> 
>> Yes it's also a client of the fuse device, but that term is confusing.
>
> Okay, will do s/client/server/g
>
>>> Anyways, doing it directly from the server (or is it client) opens up a
>>> lot of new possibilities to screw up and I'd really much prefer staying
>>> in similar ballpark with other operations.  Maybe we can restrict it to
>>> two stages (query size & transfer) and linear consecutive ranges but
>>> then again adding retry doesn't contribute too much to the complexity.
>>> Oh.. and BTW, the in-ioctl length coding is not used universally, so it
>>> can't be depended upon.
>> 
>> I know it's not universal, some horrors I've seen in the old wireless
>> interfaces.  The question is: do we want to support such "extended"
>> ioctls?  For exmaple, does OSS have non-conformant ioctls?
>
> OSS ioctls are all pretty simple and I think they all use the proper
> encoding.  For the question, my answer would be yes (naturally).  It
> will suck later when implementing some other device only to find out
> that there's this one ioctl that needs to dereference a pointer but
> there's no supported way to do it but everything else works.
>
> I don't think the performance or the complexity of specific ioctl
> implementation is of the determining importance as long as it can be
> made to work with minimal impact on the rest of the whole thing, so
> the current retry implementation.
>
>>>>>  Also, what about containers?  How would it work then?
>>>> Dunno.  Isn't there some transformation of pids going on, so that the
>>>> global namespace can access pids in all containers but under a
>>>> different alias?  I do hope somethinig like this works, otherwise it's
>>>> not only fuse that will break.
>>> I'm not sure either.  Any idea who we should be asking about it?
>> 
>> Serge Hallyn and Eric Biederman.
>
> Okay, cc'd both.  Hello, Eric Biederman, Serge Hallyn.  For
> implementing ioctl in FUSE, it's suggested that to access the address
> space of the caller directly from the FUSE server using its pid via
> /proc/pid/mem (or task/tid/mem).  It's most likely that the calling
> process's tid will be used.  As I don't know much about the
> containers, I'm not sure how such approach will play out when combined
> with containers.  Can you enlighten us a bit?  W/o containers, it will
> look like the following.
>
>
>           FUSE ----------------
>            ^                   |
>            |                   |        kernel
>   ------ ioctl ----------- /dev/fuse ------------
>            |                   |       userland
>            |                   v
>     ---------------      -------------
>    | caller        |    | FUSE server |---> reads and writes
>    | with tid CTID |    |             |    /proc/PID/task/TID/mem
>     ---------------      -------------
>
> The FUSE server gets task->pid.  IIUC, if the FUSE server is not in a
> container, task->pid should work fine whether the caller is in
> container or not, right?  And if the FUSE server is in a container,
> it's hell lot more complex and FUSE may have to map task->pid to what
> FUSE server would know if possible?

Implementation wise it is not too bad.

           FUSE ----------------
pid = get_pid(task_tid(current))
            ^                   |
            |                   |        kernel
                          pid_vnr(pid)
   ------ ioctl ----------- /dev/fuse ------------
            |                   |       userland
            |                   v
     ---------------      -------------
    | caller        |    | FUSE server |---> reads and writes
    | with tid CTID |    |             |    /proc/PID/task/TID/mem
     ---------------      -------------

However it is a largely an insane idea.
- Write is not implemented for /proc/PID/task/TID/mem
- It would be better if the kernel handed you back a file descriptor to the
  other process memory rather than you having to generate one.
- To access /proc/PID/task/TID/mem you need to have CAP_PTRACE.
- This seems to allow for random ioctls.  With the compat_ioctl thing we have
  largely stomped on that idea.  So you should only need to deal with well
  defined ioctls.  At which point why do you need to directly access the memory
  of another process.

So why not just only support well defined ioctls and serialize them in the kernel
and allow the receiving process to deserialize them?

That would allow all of this to happen with a non-privileged server which
makes the functionality much more useful.

Given the pain it is to maintain ioctls I would be very surprised if we wanted
to open up that pandoras box even wider by allowing arbitrary user space
processes to support random ioctls.  How would you do 32/64bit support
and the like?

Eric
