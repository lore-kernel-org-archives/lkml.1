Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbXFUUcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbXFUUcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbXFUUcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:32:39 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:55324 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097AbXFUUci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:32:38 -0400
Date: Thu, 21 Jun 2007 16:32:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Subject: Problematic __attribute__((section(" "))) and gcc alignment
Message-ID: <20070621203236.GA6463@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:12:14 up 24 days,  4:50,  3 users,  load average: 0.34, 0.31, 0.52
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just realized, working on my marker infrastructure, that a lot of 
__attribute__((section(" "))) should probably come along with an
aligned() attribute. Since there are no data structures of size greater
or equal to 32 bytes put in these sections later referred to by
__sectionname_start[] and __sectionname_end[], the problem is never
encountered (AFAIK). But as soon as these structures will reach 32 bytes
in size, things will go ill:

Let's take arch/i386/boot/video.h as an example:

it defines 

struct card_info {
        const char *card_name;
        int (*set_mode)(struct mode_info *mode);
        int (*probe)(void);
        struct mode_info *modes;
        int nmodes;             /* Number of probed modes so far */
        int unsafe;             /* Probing is unsafe, only do after "scan" */
        u16 xmode_first;        /* Unprobed modes to try to call anyway */
        u16 xmode_n;            /* Size of unprobed mode range */
};

Which is 28 bytes in size (so it is ok for now). If one single field is
added, gcc will start aligning this structure on 32 bytes boundaries.
(see http://gcc.gnu.org/ml/gcc-bugs/1999-11/msg00914.html)

We then have
#define __videocard struct card_info __attribute__((section(".videocards")))
extern struct card_info video_cards[], video_cards_end[];

Which instructs gcc to put these structures in the .videocards section.
The linker scripts arch/i386/boot/setup.ld will assign video_cards and
video_cards_end as pointers to the beginning and the end of this
section. video_cards[0] is therefore expected to give the first
structure in the section.

The problem with this is that gcc will align it on 32 bytes boundaries
relative to what it "thinks" is the start of the section, which has
nothing to do with the actual section layout given by the linker script.

Therefore, gcc would add extra padding at the beginning of the
.videocards section if the structures within it would become 32 bytes
long, causing video_cards[0] to point into padding instead of the actual
data structure.

Since a change as simple as adding an element to a data structure should
not have to come with those weird alignment considerations, I think it
would make sense to turn every __attribute__((section(" ... ")))
into __attribute__((section(" ... "), aligned(sizeof(void *)))) to make
sure that gcc will not try to align the structures defined in a section
on a boundary bigger than what it thinks is the section start alignment.

Comments on this proposal are welcome,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
