Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbXFVSJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbXFVSJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758578AbXFVSJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:09:18 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:60898 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754994AbXFVSJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:09:17 -0400
Date: Fri, 22 Jun 2007 14:09:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problematic __attribute__((section(" "))) and gcc alignment
Message-ID: <20070622180915.GA15352@Krystal>
References: <20070621203236.GA6463@Krystal> <20070622172048.GA30761@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070622172048.GA30761@uranus.ravnborg.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:03:32 up 25 days,  2:42,  3 users,  load average: 0.71, 0.81, 0.73
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg (sam@ravnborg.org) wrote:
> On Thu, Jun 21, 2007 at 04:32:36PM -0400, Mathieu Desnoyers wrote:
> > Hi,
> > 
> > I just realized, working on my marker infrastructure, that a lot of 
> > __attribute__((section(" "))) should probably come along with an
> > aligned() attribute. Since there are no data structures of size greater
> > or equal to 32 bytes put in these sections later referred to by
> > __sectionname_start[] and __sectionname_end[], the problem is never
> > encountered (AFAIK). But as soon as these structures will reach 32 bytes
> > in size, things will go ill:
> > 
> > Let's take arch/i386/boot/video.h as an example:
> > 
> > it defines 
> > 
> > struct card_info {
> >         const char *card_name;
> >         int (*set_mode)(struct mode_info *mode);
> >         int (*probe)(void);
> >         struct mode_info *modes;
> >         int nmodes;             /* Number of probed modes so far */
> >         int unsafe;             /* Probing is unsafe, only do after "scan" */
> >         u16 xmode_first;        /* Unprobed modes to try to call anyway */
> >         u16 xmode_n;            /* Size of unprobed mode range */
> > };
> > 
> > Which is 28 bytes in size (so it is ok for now). If one single field is
> > added, gcc will start aligning this structure on 32 bytes boundaries.
> > (see http://gcc.gnu.org/ml/gcc-bugs/1999-11/msg00914.html)
> > 
> > We then have
> > #define __videocard struct card_info __attribute__((section(".videocards")))
> > extern struct card_info video_cards[], video_cards_end[];
> > 
> > Which instructs gcc to put these structures in the .videocards section.
> > The linker scripts arch/i386/boot/setup.ld will assign video_cards and
> > video_cards_end as pointers to the beginning and the end of this
> > section. video_cards[0] is therefore expected to give the first
> > structure in the section.
> 
> The linker will align the start of the section to the biggest alignment
> required by any member in the section. So gcc should tell the linker
> that video_cards needs 32 bytes alignemnt and we are not facing trobles.
> 
> BUT this requires that the labels in the linker script file are
> correct assigned like this:
> 
>  .tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {
>         __tracedata_start = .;
>         *(.tracedata)
>         __tracedata_end = .;
>   }
> 
> If the assignment of __tracedata_start was doen just before the .tracedata
> we would not use the alignment imposed by linker and would see the error you describe.
> 

Hi Sam,

I was experiencing problems with my addons to the DATA_DATA macro,
declaring stuff in the .data section. It looked like: 

(vmlinux.lds.h) in -mm :

/* .data section */
#define DATA_DATA                                                       \
        *(.data)                                                        \
        *(.data.init.refok)                                             \
        . = ALIGN(8);                                                  \
        VMLINUX_SYMBOL(__start___markers) = .;                          \
        *(__markers)                                                    \
        VMLINUX_SYMBOL(__stop___markers) = .;

All this is declared within the .data section. However, I could not
declare a different section within this macro, because it is already
placed in a section; i.e.

(arch/i386/vmlinux.lds.S) in -mm :
  . = ALIGN(4096);
  .data : AT(ADDR(.data) - LOAD_OFFSET) {       /* Data */
        DATA_DATA
        CONSTRUCTORS
        } :data

Using . = ALIGN(32); fixed my issue, but I wonder if there would be some
way to express the ".tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET)"
that would automatically take care of alignment within this macro?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
