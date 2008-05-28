Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbYE1LEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbYE1LEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 07:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYE1LEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 07:04:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50809 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbYE1LEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 07:04:14 -0400
Date: Wed, 28 May 2008 20:03:11 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH -mm 07/16] second chance replacement for anonymous pages
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
In-Reply-To: <20080523195535.302440037@redhat.com>
References: <20080523195506.084894989@redhat.com> <20080523195535.302440037@redhat.com>
Message-Id: <20080528195925.9CD3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------_483D3B0C000000009F64_MULTIPART_MIXED_"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------_483D3B0C000000009F64_MULTIPART_MIXED_
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit

> @@ -1129,7 +1141,11 @@ static unsigned long shrink_list(enum lr
>  {
>  	int file = is_file_lru(lru);
>  
> -	if (lru == LRU_ACTIVE_ANON || lru == LRU_ACTIVE_FILE) {
> +	if (lru == LRU_ACTIVE_FILE) {
> +		shrink_active_list(nr_to_scan, zone, sc, priority, file);
> +		return 0;
> +	}
> +	if (lru == LRU_ACTIVE_ANON && inactive_anon_low(zone)) {
>  		shrink_active_list(nr_to_scan, zone, sc, priority, file);
>  		return 0;
>  	}

I made memcgroup noreclaim infrastructure today.
and, I found slightly odd behaviour.

this condition increase OOM, because prevent active -> inactive moving 
even though non global reclaim.


--------_483D3B0C000000009F64_MULTIPART_MIXED_
Content-Type: application/octet-stream;
 name="rvr-07.1-kosaki-memcg-shrink_list.patch"
Content-Disposition: attachment;
 filename="rvr-07.1-kosaki-memcg-shrink_list.patch"
Content-Transfer-Encoding: base64

V2hlbiBtZW1jZ3JvdXAgaXMgdXNlZCwgT09NIGtpbGxlciBpcyBoYXBwZW5kIHZlcnkgZnJlcWVu
dGx5LgpiZWNhdXNlIGluYWN0aXZlX2Fub25fbG93KCkgcHJldmVudCBtb3ZlIGFjdGl2ZSBscnUg
dG8gaW5hY3RpdmUgbHJ1LgoKClNpZ25lZC1vZmYtYnk6IEtPU0FLSSBNb3RvaGlybyA8a29zYWtp
Lm1vdG9oaXJvQGpwLmZ1aml0c3UuY29tPgoKLS0tCiBtbS92bXNjYW4uYyB8ICAgIDQgKysrLQog
MSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKSW5kZXg6IGIv
bW0vdm1zY2FuLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQotLS0gYS9tbS92bXNjYW4uYworKysgYi9tbS92bXNjYW4u
YwpAQCAtMTE0NSw3ICsxMTQ1LDkgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgc2hyaW5rX2xpc3Qo
ZW51bSBscgogCQlzaHJpbmtfYWN0aXZlX2xpc3QobnJfdG9fc2Nhbiwgem9uZSwgc2MsIHByaW9y
aXR5LCBmaWxlKTsKIAkJcmV0dXJuIDA7CiAJfQotCWlmIChscnUgPT0gTFJVX0FDVElWRV9BTk9O
ICYmIGluYWN0aXZlX2Fub25fbG93KHpvbmUpKSB7CisKKwlpZiAobHJ1ID09IExSVV9BQ1RJVkVf
QU5PTiAmJgorCSAgICAoIXNjYW5fZ2xvYmFsX2xydShzYykgfHwgaW5hY3RpdmVfYW5vbl9sb3co
em9uZSkpKSB7CiAJCXNocmlua19hY3RpdmVfbGlzdChucl90b19zY2FuLCB6b25lLCBzYywgcHJp
b3JpdHksIGZpbGUpOwogCQlyZXR1cm4gMDsKIAl9Cg==
--------_483D3B0C000000009F64_MULTIPART_MIXED_--


