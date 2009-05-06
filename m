Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbZEFTZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbZEFTZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 15:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759150AbZEFTZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 15:25:08 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:49158 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbZEFTZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 15:25:07 -0400
Date: Wed, 6 May 2009 15:24:21 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.lan
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: __setup_param(), unique_id and vdso_setup
Message-ID: <alpine.LFD.2.00.0905061519050.32023@localhost.lan>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  just going through my outstanding list of kernel cleanup pedantry,
and i was reminded of this from include/linux/init.h:

=====
...
#define __setup(str, fn)                                        \
        __setup_param(str, fn, fn, 0)

/* NOTE: fn is as per module_param, not __setup!  Emits warning if fn
 * returns non-zero. */
#define early_param(str, fn)                                    \
        __setup_param(str, fn, fn, 1)
...
=====

  in short, both invocations of __setup_param() use identical second
and third parameters, and a tree-wide grep shows:

$ grep -rw __setup_param *
arch/x86/vdso/vdso32-setup.c:__setup_param("vdso=", vdso32_setup, vdso_setup, 0);
include/linux/init.h:#define __setup_param(str, unique_id, fn, early)                   \
include/linux/init.h:   __setup_param(str, fn, fn, 0)
include/linux/init.h:   __setup_param(str, fn, fn, 1)
include/linux/init.h:#define __setup_param(str, unique_id, fn)  /* nothing */
$

  so apart from that single exception involving "vdso", that macro
could be simplified to just get rid of that third parameter.  is there
something special about the vdso boot-time parm that *requires* it to
be the only boot-time parm in the entire kernel to have a different
unique id?  just curious.  or does that have to be preserved for
out-of-tree builds?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
