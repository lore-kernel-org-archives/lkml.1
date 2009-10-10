Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbZJJXmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbZJJXmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 19:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757098AbZJJXmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 19:42:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52566 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755013AbZJJXmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 19:42:14 -0400
Date: Sun, 11 Oct 2009 00:42:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vincent Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sound_core.c: Remove BKL from soundcore_open
Message-ID: <20091011004219.74c30f67@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0910110123510.4921@localhost.localdomain>
References: <alpine.LFD.2.00.0910110123510.4921@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009 01:24:14 +0200 (CEST)
John Kacur <jkacur@redhat.com> wrote:

> >From 030af455d4f54482130c8eccb47fe90aaba8808c Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Sat, 10 Oct 2009 23:39:56 +0200
> Subject: [PATCH] This code is already protected by spin_lock, and doesn't require the bkl

Sorry but I don't think that is true becaue of:

           spin_unlock(&sound_loader_lock);
                if(file->f_op->open)
                        err = file->f_op->open(inode,file);


So the underlying driver open method expects lock_kernel status and you
don't propogate it down. You really need to track down each thing that
can be called into here and fix it, or maybe just punt for the moment and
push it down to

	{
		lock_kernel()
		err = file-f_op->open ...
		unlock_kernel()
	}

so its obvious to the next person who takes up the war on the BKL what is
to be tackled.
