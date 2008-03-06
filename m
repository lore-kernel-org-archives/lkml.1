Return-Path: <linux-kernel-owner+w=401wt.eu-S934632AbYCFOVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934632AbYCFOVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 09:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764317AbYCFOVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 09:21:00 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58086 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762470AbYCFOU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 09:20:59 -0500
Date: Thu, 6 Mar 2008 16:20:57 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Patrick McHardy <kaber@trash.net>
cc: Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       clameter@sgi.com, joe@perches.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: replace horrible hack with ksize()
In-Reply-To: <Pine.LNX.4.64.0803061612290.4202@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0803061618090.4378@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0803052319210.15759@sbz-30.cs.Helsinki.FI>
 <47CFF9B7.5060803@trash.net> <Pine.LNX.4.64.0803061612290.4202@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Pekka J Enberg wrote:
> > > -	if (newlen >= ct->ext->real_len) {
> > > +	if (newlen >= ksize(ct->ext)) {
> > 
> > This needs to look at the currently allocated size, otherwise
> > it will always realloc when adding new extensions after having
> > used up ksize(ct->ext) space.
> 
> Lets say you
> 
>   p = kmalloc(8, ...);
> 
> Then ksize(p) will return the currently allocated size which is 32 bytes 
> when page size is 4 KB, and not 8 bytes. So it should be equivalent of 
> what the current code does.
> 
> What am I missing here?

Ok, it's not equivalent. We have two sizes: object size (8 bytes) and 
buffer size (32 bytes) here. In netfilter, ->real_len is same as object 
size, not buffer size as ksize() is.

But now I am officially even more confused, why does the netfilter code 
decided whether to reallocate based on _object size_ and not _buffer size_ 
(as krealloc() does, for example)?

			Pekka
