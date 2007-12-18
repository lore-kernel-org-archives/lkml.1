Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbXLRIir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbXLRIir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 03:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbXLRIii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 03:38:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:4521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbXLRIih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 03:38:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,179,1196668800"; 
   d="scan'208";a="446563663"
Subject: Re: [PATCH 1/4 -mm] kexec based hibernation -v7 : kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <m163z51sz3.fsf@ebiederm.dsl.xmission.com>
References: <1197042810.24045.61.camel@caritas-dev.intel.com>
	 <m1tzmq0xy0.fsf@ebiederm.dsl.xmission.com>
	 <1197388219.11506.32.camel@caritas-dev.intel.com>
	 <m163z51sz3.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Dec 2007 16:34:22 +0800
Message-Id: <1197966862.12999.68.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 18 Dec 2007 08:34:26.0549 (UTC) FILETIME=[CC93DA50:01C84150]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-11 at 02:27 -0700, Eric W. Biederman wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> 
> > On Mon, 2007-12-10 at 19:25 -0700, Eric W. Biederman wrote:
> >> "Huang, Ying" <ying.huang@intel.com> writes:
> > [...]
> >> >  /*
> >> >   * Do not allocate memory (or fail in any way) in machine_kexec().
> >> >   * We are past the point of no return, committed to rebooting now.
> >> >   */
> >> > -NORET_TYPE void machine_kexec(struct kimage *image)
> >> > +int machine_kexec_vcall(struct kimage *image, unsigned long *ret,
> >> > +			 unsigned int argc, va_list args)
> >> >  {
> >> 
> >> Why do we need var arg support?
> >> Can't we do that with a shim we load from user space?
> >
> > If all parameters are provided in user space, the usage model may be as
> > follow:
> >
> > - sys_kexec_load() /* with executable/data/parameters(A) loaded */
> > - sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,) /* execute physical mode code with
> > parameters(A)*/
> > - /* jump back */
> > - sys_kexec_load() /* with executable/data/parameters(B) loaded */
> > - sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,) /* execute physical mode code with
> > parameters(B)*/
> > - /* jump back */
> >
> > That is, the kexec image should be re-loaded if the parameters are
> > different, and there can be no state reserved in kexec image. This is OK
> > for original kexec implementation, because there is no jumping back.
> > But, for kexec with jumping back, another usage model may be useful too.
> >
> > - sys_kexec_load() /* with executable/data loaded */
> > - sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,parameters(A)) /* execute physical mode
> > code with parameters(A)*/
> > - sys_reboot(,,LINUX_REBOOT_CMD_KEXEC,parameters(B)) /* execute physical mode
> > code with parameters(B)*/
> >
> > This way the kexec image need not to be re-loaded, and the state of
> > kexec image can be reserved across several invoking.
> 
> Interesting.  We wind up preserving the code in between invocations.
> 
> I don't know about your particular issue, but I can see that clearly
> we need a way to read values back from our target image.
> 
> And if we can read everything back one way to proceed is to read
> everything out modify it and then write it back.
> 
> Amending a kexec image that is already stored may also make sense.
> 
> I'm not convinced that the var arg parameters make sense, but you
> added them because of a real need.
> 
> The kexec function is split into two separate calls so that we can
> unmount the filesystem the kexec image comes from before actually
> doing the kexec.

My real issue is that I need a kind of "kernel to kernel" communication
method. The var args is just a convenient way to pass an array of
unsigned longs between two kernels. The reason is as follow:

The kexec based hibernating process is as follow:

h1. put devices in quiescent state
h2. save devices/CPU state
h3. jump to kexeced kernel (kernel B)
*h4. normal kernel boot of kernel B
*h5. save devices/CPU state
*h6. jump back to original kernel (kernel A)
h7. restore devices/CPU state
h8. put devices in quiescent state
h9. put devices in low power state
h10. execute necessary ACPI method (prepare to sleep)
h11. save devices/CPU state
h12. jump to kernel B
*h13. execute necessary ACPI method (wake up)
*h14. restore devices/CPU state
*h15. put devices in normal power state
*h16. write memory image of kernel A into disk
*h17. put system into ACPI S4 state

The kexec based resuming process is as follow:

*r1. boot the resuming kernel (kernel C)
*r2. restore the memory image of kernel A
*r3. put devices in quiescent state
*r4. execute necessary ACPI method (prepare to resume)
*r5. jump to kernel A
r6. execute necessary ACPI method (wake up)
r7. restore devices/CPU state

Where, line begin with "*" is executed in kernel B and kernel C, others
are executed in kernel A.

The kernel A need to distinguish the difference between h7 and r6, while
the kernel B/C need to distinguish between *h13 and normal jump back.
The different kernel action need to be taken depends on the action of
peer kernel. Now, this is solved by kernel-kernel communication, a
command word is passed to peer kernel to inform the action required.

I remember you have said before that you think it is better to use only
"user space to user space" communication between kernel A and kernel B.
This is OK for normal kexec. But if the kexec jump is used for multiple
functions with early kernel action involved (normal kexec jump, kexec
jump to hibernate, kexec jump to resume), it is necessary to use "kernel
to kernel" communication.

The var args in the patch is just an array of unsigned longs, it can be
expresses as follow too.

int kexec_call(struct kimage *image, unsigned long *ret, unsigned int
argc, unsigned long argv[]);

The var args version is as follow.

int kexec_call(struct kimage *image, unsigned long *ret, unsigned int
argc, ...);

Best Regards,
Huang Ying

