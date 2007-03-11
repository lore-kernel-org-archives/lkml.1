Return-Path: <linux-kernel-owner+w=401wt.eu-S933848AbXCKREJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848AbXCKREJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 13:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933850AbXCKREJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 13:04:09 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:27511 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933848AbXCKREH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 13:04:07 -0400
Message-ID: <45F437C9.2090108@sw.ru>
Date: Sun, 11 Mar 2007 20:09:29 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Herbert Poetzl <herbert@13thfloor.at>
CC: Srivatsa Vaddagiri <vatsa@in.ibm.com>, menage@google.com, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
       containers@lists.osdl.org, akpm@linux-foundation.org,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru
Subject: Re: [PATCH 1/2] rcfs core patch
References: <20070301133543.GK15509@in.ibm.com> <20070301134528.GL15509@in.ibm.com> <m1slcg8m4f.fsf@ebiederm.dsl.xmission.com> <20070308101347.GA29051@in.ibm.com> <20070309004816.GB4506@MAIL.13thfloor.at> <45F127AB.5070704@sw.ru> <20070309132136.GA14907@MAIL.13thfloor.at>
In-Reply-To: <20070309132136.GA14907@MAIL.13thfloor.at>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert,

> sorry, I'm not in the lucky position that I get payed
> for sending patches to LKML, so I have to think twice
> before I invest time in coding up extra patches ...
> 
> i.e. you will have to live with my comments for now
looks like you have no better argurments then that...

>>Looks like your main argument is non-intrusive...
>>"working", "secure", "flexible" are not required to 
>>people any more? :/
> 
> 
> well, Linux-VServer is "working", "secure", "flexible"
> _and_ non-intrusive ... it is quite natural that less
> won't work for me ... and regarding patches, there
> will be a 2.2 release soon, with all the patches ...
ok. please check your dcache and slab accounting then
(analyzed according to patch-2.6.20.1-vs2.3.0.11.diff):
Both are full of races and problems. Some of them:
1. Slabs allocated from interrupt context are charged to current context.
   So charged values contain arbitrary mess, since during interrupts
   context can be arbitrary.
2. Due to (1) I guess you do not make any limiting of slabs.
   So there are number of ways how to consume a lot of kernel
   memory from inside container and
   OOM killer will kill arbitrary tasks in case of memory-shortage after that.
   Don't think it is secure... real DoS.
3. Dcache accounting simply doesn't work, since
   charges/uncharges are done on current context (sic!!!), which is arbitrary.
   i.e. lookup can be done in VE context, while dcache shrink can be done
   from another context.
   So the whole problem with dcache DoS is not solved at all, it is just hard to trigger.
4. Dcache accounting is racy, since your checks look like:
   if (atomic_read(de->d_count))
      charge();
   which obviously races with other dput()'s/lookups.
5. Dcache accounting can be hit if someone does `find /` inside container.
   After that it is impossible to open something new,
   since all the dentries for directories in dcache will have d_count > 0
   (due it's children).
   It is a BUG.
6. Counters can be non-zero on container stop due to all of the above.

There are more and more points which arise when such a non-intrusive
accounting is concerned. I'm really suprised, that you don't see them
or try to behave as you don't see them :/
And, please, believe me, I would not suggest so much complicated patches
If everything was so easy and I had no reasons simply to accept vserver code.

> well, as you know, all current solutions use a syscall
> interface to do most of the work, in the OpenVZ/Virtuozzo
> case several, unassigned syscalls are used, while 
> FreeVPS and Linux-VServer use a registered and versioned
> (multiplexed) system call, which works quite fine for
> all known purposes ...
> 
> I'm quite happy with the extensibility and flexibility
> the versioned syscall interface has, the only thing I'd
> change if I would redesign that interface is, that I
> would add another pointer argument to eliminate 32/64bit
> issues completely (i.e. use 4 args instead of the 3)
Well, I would be happy with syscalls also.
But my guess is that cpuset guys who already use fs approach won't be happy :/
Maybe we can use both?

Thanks,
Kirill

