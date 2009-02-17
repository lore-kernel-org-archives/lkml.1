Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbZBQTnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbZBQTnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZBQTnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:43:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:6912 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZBQTnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:43:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=D/K2OGa7indk2Tno/bpy2sWEPi3LbOShnAf49Ol8kAg9yflc5mLjqfxgDTM6jkJfpF
         jf9BLLyjZQTrLSLrDaiKp0QT0qx3F7SGF/iLscjNUcRfgrDBdbdPPkkbp+zLDlM1bDCR
         NwC16AFMGlbyHKfjgr66BAbLCR46V8VWVZ+Cw=
MIME-Version: 1.0
In-Reply-To: <20090217181157.GA2158@cmpxchg.org>
References: <20090123154653.GA14517@wotan.suse.de>
	 <200902041748.41801.nickpiggin@yahoo.com.au>
	 <20090204152709.GA4799@csn.ul.ie>
	 <200902051459.30064.nickpiggin@yahoo.com.au>
	 <20090216184200.GA31264@csn.ul.ie> <4999BBE6.2080003@cs.helsinki.fi>
	 <alpine.DEB.1.10.0902171120040.27813@qirst.com>
	 <1234890096.11511.6.camel@penberg-laptop>
	 <alpine.DEB.1.10.0902171204070.15929@qirst.com>
	 <20090217181157.GA2158@cmpxchg.org>
Date: Tue, 17 Feb 2009 21:43:10 +0200
X-Google-Sender-Auth: 560bef67a2ebd23a
Message-ID: <84144f020902171143i5844ef83h20cb4bee4f65c904@mail.gmail.com>
Subject: Re: [patch] SLQB slab allocator (try 2)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 12:05:07PM -0500, Christoph Lameter wrote:
>> Index: linux-2.6/include/linux/slub_def.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/slub_def.h   2009-02-17 10:45:51.000000000 -0600
>> +++ linux-2.6/include/linux/slub_def.h        2009-02-17 11:06:53.000000000 -0600
>> @@ -121,10 +121,21 @@
>>  #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
>>
>>  /*
>> + * Maximum kmalloc object size handled by SLUB. Larger object allocations
>> + * are passed through to the page allocator. The page allocator "fastpath"
>> + * is relatively slow so we need this value sufficiently high so that
>> + * performance critical objects are allocated through the SLUB fastpath.
>> + *
>> + * This should be dropped to PAGE_SIZE / 2 once the page allocator
>> + * "fastpath" becomes competitive with the slab allocator fastpaths.
>> + */
>> +#define SLUB_MAX_SIZE (2 * PAGE_SIZE)

On Tue, Feb 17, 2009 at 8:11 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> This relies on PAGE_SIZE being 4k.  If you want 8k, why don't you say
> so?  Pekka did this explicitely.

That could be a problem, sure. Especially for architecture that have 64 K pages.
