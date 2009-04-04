Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZDDGFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZDDGFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 02:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZDDGEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 02:04:55 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:43988 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751025AbZDDGEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 02:04:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cPxgpOtgCZ0MImLRNz4cVRUwmd1y9xVGRPTFnMiNp4g9M2OLCqZoAOwD64wPaTxSW829yanSmdUqAPl/nCK+KRgB53g313TpcJJuFTF4GooHWDgeFYkqUwxJVwg2Qh/1Rq/AqvRBCG8Fca2nHL/NKh6qro6DY5nauDEWKNcCJlI=  ;
X-YMail-OSG: j6iy4zsVM1npU2a_LFQdNy40iwuc0jBlokw1Hw7LUjcG1Vvic2nKaP.7KNpf8T6DFE5aAQUXHDr86HwTHHZohJtjcMtYN7ntDOz4Nq.xrGjuP.NClxo0uEsairWm3NmNy_HCTCyCRmKZSLERe64ARNK3.__9CkujKUEgm22H5NiI6Vkzt1OMdR01wAE3Av4L6w2Wx_Ik0pWXxD7SyjvJelWOScgLSkAm3scUhIQhMpHibUk_V0f1R2jUaB2ER3vvQOPmIWqpU68ZHIJ8Or.gcSFrl7Ep07cBLOFZSC3.W_5EpbpJv2iY
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 06/41] FS-Cache: Recruit a page flags for cache management [ver #48]
Date: Sat, 4 Apr 2009 17:04:49 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-fsdevel@vger.kernel.org
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk> <20090403155507.28714.13233.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155507.28714.13233.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904041704.49584.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And frame changelogs like this as what the patch is actually doing.

mm: add another page bit to signal fs private data

Add a new flag PG_private_2 which, similarly to PG_private, instructs
the mm to call into the fs when releasing or invalidating the page.

fscache will use this for blah blah blah.


> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -283,7 +283,7 @@ static inline int page_mapping_inuse(struct page *page)
>  
>  static inline int is_page_cache_freeable(struct page *page)
>  {
> -	return page_count(page) - !!PagePrivate(page) == 2;
> +	return page_count(page) - !!page_has_private(page) == 2;
>  }
>  
>  static int may_write_to_queue(struct backing_dev_info *bdi)

What if the page has both private bits set? Will this count for 2 references?
If not, that's unintuitive and needs commenting somewhere so nobody else who
might use this bit will end up with memory leaks. If so, then you need to
modify this check to account for both possible references.
