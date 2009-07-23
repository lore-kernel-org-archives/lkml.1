Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZGWOql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZGWOql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZGWOqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:46:40 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40668 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbZGWOqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:46:40 -0400
Subject: Re: [RFCv2][PATCH] flexible array implementation
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: vda.linux@googlemail.com, bblum@google.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, menage@google.com,
       akpm@linux-foundation.org
In-Reply-To: <4A67CEB7.2080505@zytor.com>
References: <20090721220017.60A219D3@kernel>  <4A67CEB7.2080505@zytor.com>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 07:30:01 -0700
Message-Id: <1248359401.24021.715.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 19:45 -0700, H. Peter Anvin wrote:
> > I call it a flexible array.  It does all of its work in
> > PAGE_SIZE bits, so never does an order>0 allocation.
> > The base level has PAGE_SIZE-2*sizeof(int) bytes of
> > storage for pointers to the second level.  So, with a
> > 32-bit arch, you get about 4MB (4183112 bytes) of total
> > storage when the objects pack nicely into a page.  It
> > is half that on 64-bit because the pointers are twice
> > the size.
> 
> I'm wondering if there is any use case which would require scaling below
> the PAGE_SIZE level... in which case it would be nice for it to
> gracefully decay to a single kmalloc allocation + some metadata.

For the pid_t case that actually spawned all this, I think it makes a
ton of sense.  It should be pretty easy to just cannibalize the
base->part[] pointers to use for data if (total*element_size <=
bytes_allocated - sizeof(metadata)) in the base.  We'd have to store the
requested allocation total, but that's not bad.

1. Do we use this mode *only* when using a small 'total'?  Or, do we
   use the mode only when accessing a small range of elements, like
   indexes < 511.
2. Do we just use the mode when the indexes are large, but not sparse?
   Say, when someone is only using indexes 1024->1535?
3. Do we ever allocate less than 1 page (i.e. kmalloc(2048)) for the
   base given a small enough 'total' requested?  If so, it gets much
   harder to grow the array later on if we want to support resizing.
4. Do we ever promote under the covers from this mode up to the full
   two-level one?

This also gives us more of a reason to store a flex_array->total and
enforce that the array is not allowed to grow past that.

-- Dave

