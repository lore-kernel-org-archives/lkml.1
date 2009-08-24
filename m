Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbZHXP40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbZHXP40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZHXP4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:56:25 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36193 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbZHXP4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:56:25 -0400
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 08:56:24 -0700
Message-Id: <1251129384.22398.7166.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 16:21 -0700, David Rientjes wrote:
> 
> diff --git a/include/linux/poison.h b/include/linux/poison.h
> --- a/include/linux/poison.h
> +++ b/include/linux/poison.h
> @@ -65,6 +65,9 @@
>  #define MUTEX_DEBUG_INIT       0x11
>  #define MUTEX_DEBUG_FREE       0x22
> 
> +/********** lib/flex_array.c **********/
> +#define FLEX_ARRAY_FREE        0x6c    /* for use-after-free poisoning */

This seems like a good idea, but perhaps we should pick a non-ASCII
character as the poison value.  If someone ever tried to store strings
as one-byte elements, they'd be in for a rude awakening the first time
they store an 'l'.

Or, maybe we should just disable poisoning if the elements are 4 bytes
or less.  Or, perhaps the minimum element size should just be 4 bytes
and we have a 4-byte poison value.  

The other alternative is to just use '\0' as the cleared value.  We
won't be able to track whether accesses in the middle of the array are
valid, but we can at least always shrink the array with no fear of
misdetection of the poison value.  That also rids us of some of the
logic around GFP_ZERO and the poisoning that is a bit confusing.

Do you think it is confusing that passing GFP_ZERO will keep you from
doing a shrink unless you do a clear for all of the allocated data?
Should we expose some of the functions so that users can tell if what
was allocated precisely?

-- Dave

