Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbZC1RWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbZC1RWm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 13:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZC1RWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 13:22:32 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:24354 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbZC1RWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 13:22:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jFrOhu4I5mG2w4HF3WLIn3Zp5e4DSLbjtMankoJknQQmRaTLfNJj+yLPInEVmDD8zo
         ifEo3GUOftcrAUPaHSLLYNFnBsvLN3AdcfU4qSQDqrSeveYTc8AmLlYZ6nGuu3NtIFK8
         lf6JYjqrLNkTq17CFmQzInMoykowQXypO2I/U=
Subject: Re: Linux 2.6.29
From: David Hagood <david.hagood@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Mark Lord <lkml@rtr.ca>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0903280916230.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu>
	 <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu>
	 <20090327145156.GB24819@srcf.ucam.org>
	 <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
	 <20090327152221.GA25234@srcf.ucam.org>
	 <20090327161553.31436545@lxorguk.ukuu.org.uk>
	 <20090327162841.GA26860@srcf.ucam.org>
	 <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk>
	 <20090327170208.GA27646@srcf.ucam.org>
	 <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
	 <49CD2C47.4040300@garzik.org>
	 <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain>
	 <49CD4DDF.3000001@garzik.org>
	 <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
	 <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>
	 <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>
	 <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
	 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de>
	 <49CE3F74.6090103@rtr.ca> <49CE4B99.1090006@s5r6.in-berlin.de>
	 <alpine.LFD.2.00.0903280916230.3994@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 12:22:26 -0500
Message-Id: <1238260946.29177.11.camel@surfer>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What if you added another phase in the journaling, after the data is
written to the kernel, but before block allocation.

As I understand, the current scenario goes like this:
1) A program writes a bunch of data to a file.
2) The kernel holds the data in buffer cache, delaying allocation.
3) Kernel updates file metadata in journal.
4) Some time later, kernel allocates blocks and writes data.

If things go boom between 3 and 4, you have the files in an inconsistent
state. If the program does an fasync(), then the kernel has to write ALL
data out to be consistent.

What if you could do this:

1) A program writes a bunch of data to a file.
2) The kernel holds the data in buffer cache, delaying allocation.
3) The kernel writes a record to the journal saying "This data goes with
this file, but I've not allocated any blocks for it yet."
4) Kernel updates file metadata in journal.
5) Sometime later, kernel allocates blocks for data, and notes the
allocation in the journal.
6) Sometime later still the kernel commits the data to disk and update
the journal.

It seems to me this would be a not-unreasonable way to have both the
advantages of delayed allocation AND get the data onto disk quickly.

If the user wants to have speed over safety, you could skip steps 3 and
5 (data=ordered). You want safety, you force everything through steps 3
and 5 (data=journaled). You want a middle ground, you only do steps 3
and 5 for files where the program has done an fasync() (data=ordered +
program calls fasync()).

And if you want both speed and safety, you get a big battery-backed up
RAM disk as the journal device and journal everything.


