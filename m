Return-Path: <linux-kernel-owner+w=401wt.eu-S935880AbXLQVzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935880AbXLQVzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760215AbXLQVzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:55:22 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58413 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbXLQVzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:55:20 -0500
Date: Mon, 17 Dec 2007 23:55:17 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: John Reiser <jreiser@BitWagon.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: slab quirks in DEBUG, ctor, and initialization
In-Reply-To: <4766E7D7.6050003@BitWagon.com>
Message-ID: <Pine.LNX.4.64.0712172343370.22511@sbz-30.cs.Helsinki.FI>
References: <47669A16.3010604@BitWagon.com> <84144f020712171151j5e2a2934qc8bf2fbc9020a545@mail.gmail.com>
 <4766E7D7.6050003@BitWagon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Mon, 17 Dec 2007, John Reiser wrote:
> idr_pre_get calls kmem_cache_alloc, which constructs 'struct idr_layer'
> via the cachep->ctor() call from cache_alloc_debugcheck_after to
> idr_cache_ctor, and not via cache_init_objs.  So if DEBUG is off,
> then idr_cache_ctor does not get its chance to call memset,
> which could leave the struct idr_layer potentially undefined.

No, init_cache_objs() will call the constructor, if the cache has one when 
DEBUG is not set so the struct idr_layer can never be undefined. However, 
struct idr_layer can contain non-zero elements if someone does a 
kmem_cache_free() on an object that hasn't been zeroed. If that matters 
here, idr_pre_get should call kmem_cache_zalloc() and drop the 
constructor.

				Pekka
