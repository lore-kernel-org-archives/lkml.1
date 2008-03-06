Return-Path: <linux-kernel-owner+w=401wt.eu-S1763665AbYCFPuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763665AbYCFPuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758910AbYCFPu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:50:28 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44064 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845AbYCFPu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:50:26 -0500
Message-ID: <47D01277.9060807@cs.helsinki.fi>
Date: Thu, 06 Mar 2008 17:49:11 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       clameter@sgi.com, joe@perches.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: replace horrible hack with ksize()
References: <Pine.LNX.4.64.0803052319210.15759@sbz-30.cs.Helsinki.FI> <47CFF9B7.5060803@trash.net> <Pine.LNX.4.64.0803061612290.4202@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0803061618090.4378@sbz-30.cs.Helsinki.FI> <47D0014D.1060901@trash.net> <Pine.LNX.4.64.0803061640380.4820@sbz-30.cs.Helsinki.FI> <47D004DB.4010105@trash.net>
In-Reply-To: <47D004DB.4010105@trash.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Patrick,

Patrick McHardy wrote:
> > I think you are misunderstanding ksize() (see mm/slub.c::ksize() for 
> > example).
> 
> The ksize() description in mm/slab.c matches exactly what netfilter
> wants to do:

Agreed.

Patrick McHardy wrote:
> The initial allocation size is calculated as max(size, min slab size)
> and is stored as ext->alloc_size. When adding the first extension,

Yes, this part is correct, however...

> it allocates ext->alloc_size of memory and stores both the real amount
> of space used (ext->len) and the actual size (ext->real_len).
> When adding further extensions, it calculates the new total amount of
> space needed (newlen). If that is larger than the real amount of
> memory allocated (real_len), it reallocates.

...looking at nf_ct_ext_create() you do:

         *ext = kzalloc(real_len, gfp);
                        ^^^^^^^^
         if (!*ext)
                 return NULL;

         (*ext)->offset[id] = off;
         (*ext)->len = len;
         (*ext)->real_len = real_len;
                            ^^^^^^^^

You are storing the _object size_ (total amount of memory requested) and 
not the _buffer size_ (total amount of memory allocated). Keep in mind 
that object size < buffer size and that ksize() returns the latter.

Now continuing in __nf_ct_ext_add() you do:

        if (newlen >= ct->ext->real_len) {
                               ^^^^^^^^
                 new = kmalloc(newlen, gfp);
                 if (!new)
                         return NULL;

So you're comparing newlen to the object size and not the buffer size 
which is what you want and what ksize() and consequently my patch does.

Take a look at mm/util.c::krealloc(). It does exactly what you want 
modulo the RCU bits. My patch converts the netfilter code to follow the 
exact same semantics.

			Pekka
