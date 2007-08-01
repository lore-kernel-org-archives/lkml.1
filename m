Return-Path: <linux-kernel-owner+w=401wt.eu-S1764752AbXHAM3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764752AbXHAM3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761022AbXHAM3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:29:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760706AbXHAM3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:29:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <46695F6D.5050600@t-online.de>
References: <46695F6D.5050600@t-online.de>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Wu, Bryan" <Bryan.Wu@analog.com>
Subject: Re: [PATCH, RFD]: Unbreak no-mmu mmap
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Wed, 01 Aug 2007 13:29:07 +0100
Message-ID: <19618.1185971347@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schmidt <bernds_cb1@t-online.de> wrote:
> 1. munmap can now unmap subparts of previously allocated blocks.  This
>    makes behaviour more consistent with mmu Linux, and allows us to
>    simplify and speed up the uClibc malloc implementation.

There's a problem with your alteration to do_munmap() to split VMAs.  What
happens if an area of a file is mmap'd twice in a process?  Consider the
situation where two independent parts of a process (say two different
libraries) each map an area of the same file.  do_mmap_pgoff() will attempt to
share these regions if it can.

This can lead to you splitting the wrong VMA when someone comes along later to 
do an apparent partial unmap.

I'm currently working on something to give each NOMMU process its own list
VMAs rather than holding them in common.  This is so that I can add VMA
reservation (and more to the point, unreservation) which'll make some stuff
easier.

David
