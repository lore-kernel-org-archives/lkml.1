Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbZC0WHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbZC0WHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbZC0WGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:06:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157AbZC0WGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:06:53 -0400
Date: Fri, 27 Mar 2009 15:01:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49CD32E1.2020906@ursus.ath.cx>
Message-ID: <alpine.LFD.2.00.0903271452521.3994@localhost.localdomain>
References: <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org>
 <20090327171955.78662c1e@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0903271058060.3994@localhost.localdomain> <20090327190339.GW6239@mit.edu> <20090327191426.3d478b6b@lxorguk.ukuu.org.uk> <20090327193249.GY6239@mit.edu> <49CD32E1.2020906@ursus.ath.cx>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Andreas T.Auer wrote:
> 
> > The fundamental idea here is not all files need to be forced to disk
> > on close.  Not all files need fsync(), or even fbarrier().
>
> An fbarrier() on close() would reflect the thinking of a lot of
> developers.

It also happens to be what pretty much all network filesystems end up 
implementing.

That said, there's a reason many people prefer local filesystems to even 
high-performance NFS - latency (especially for metadata which even modern 
versions of NFS cannot cache effectively) just sucks when you have to go 
over the network. It pretty much doesn't matter _how_ fast your network or 
server is.

One thing that might make sense is to make "close()" start background 
writeout for that file (modulo issues like laptop mode) with low priority. 

No, it obviously doesn't guarantee any kind of filesystem coherency, but 
it _does_ mean that the window for the bad cases goes from potentially 30 
seconds down to fractions of seconds. That's likely quite a bit of 
improvement in practice.

IOW, no "hard barriers", but simply more of a "even in the absense of 
fsync we simply aim for the user to have to be _really_ unlucky to ever 
hit any bad cases".

			Linus
