Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYAFDUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYAFDUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYAFDTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:19:55 -0500
Received: from queueout01-winn.ispmail.ntl.com ([81.103.221.31]:10451 "EHLO
	queueout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036AbYAFDTy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:19:54 -0500
Date: Sun, 6 Jan 2008 03:13:43 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: mathewss <mathewss@mail.nutech.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: init wont start on VIA EPIA 5000 500mhz board and randomely wont start on VIA EPIA MII 10000
Message-ID: <20080106031343.GB642@deepthought>
References: <200801051714.AA13500470@mail.nutech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200801051714.AA13500470@mail.nutech.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 05:14:08PM -0800, mathewss wrote:
> I have been trying to figure this out a while now with printk's all over my kernel as well as adding kdb and tracing the int3 events.
> 
> I have tried various 2.6 kernels and so far all i have tried do this.
> 
>  My current tests are on 2.6.22.10 
> 
>  I have a simple init binary I compiled static that is my init that is loaded into an init file system. I am not using cpio but that did not seem to matter.
> ---- begin testinit.c
> #include <stdio.h>
> #include <unistd.h>
> int main(int argc, char *argv[])
> {
>    printf("Hello world!\n");
>    sleep(999999999);
> }
> ---- end
> 
>  I am using syslunux to start my kernel and appending the follwiing startup command most of this is specific to my true init script but again im using a "hello world" script to debug this for now.
> 
> append  debug kidb=early console=ttyS0,384008n initrd=ufoinit.img init=/testinit rw var_size=12M tmp_size=MAX log_size=16M root_size=64M root=/dev/ram0 boot=/dev/hda1,msdos rw pkgpath=/dev/hda1:msdos rw verbose DELAY=0 TEST=0 DEBUG=0 VERBOSE=0 UFO=root,etc,modules
> 
>  On an intel CA810EEA 800mhz board or QEMU this runs fine but on the via boards it dies right after "Freeing unused kernel memory: 132k freed"
>  
 That will be where it invokes the init program, I think, so the
kernel is probably not to blame.

>  on the 500mhz board it dies every time on the 800mhz it is random.
> 

 For the 500MHz, this sounds like the "i686 implies cmov" problem -
gcc thinks that all i686 CPUs understand a particular instruction
('cmov', if my brain cells haven't totally given up), but early via
processors didn't.  Haven't seen too many references to this
recently, so perhaps recent versions of gcc have fixed this, or
perhaps people know of a workaround.

 I suggest that your userspace (glibc and gcc, I suppose) is built
for i686 and uses the instruction that your CPU doesn't understand.

 The 800MHz might be different, I thought those did provide the
instruction.  Have you checked the memory with memtest86 ?  For the
cases where it doesn't die, perhaps you should give it an init which
is going to do something, and see if it actually manages to boot any
of the time.  If so, that would confirm that the two CPUs are not
identical in their capabilities.  It wouldn't explain the less than
100% success, of course, so the usual suspects (crap hardware,
failing memory, dodgy power supplies) would need to be investigated.

 As always, this is intended to be helpful, but treat it with a
grain of salt, I could well be talking out of a different orifice
than my mouth.  My last experience with a via processor was a 1.2GHz
beastie which certainly understood all i686 instructions, but
managed to make snails look fast, and wasn't as power-frugal as
expected, so I might be prejudiced.

>  I have noticed that i get the elf binarly loading into user space with some page_faults then I get blasted with do_notify_resume with 0x04 or TIF_SIGPENDING over and over as if its in an infinite loop.
> 
>  This begins shortly after load_elf_binary -> clear_user i think right after a page_fault during the clear_user. I dont even know why that signal is being sent on other hardware it never happens.
> 
>  I am not even sure what do try next.
> 

 Find a toolchain built for i586 ? (Or preferably i486, I think I
remember comments that early via CPUs run better when optimised for
i486).

 If you think your own toolchain is compiled for i586, you could try
downloading one of the distros which definitely is built for i586 or
i486 - if that works, it's a userspace compile problem.  Or, perhaps,
the kernel actually needs to be built for i486 - I doubt that, but I
don't have the hardware.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
