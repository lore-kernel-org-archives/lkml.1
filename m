Return-Path: <linux-kernel-owner+w=401wt.eu-S1761020AbYGBWvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020AbYGBWvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 18:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbYGBWvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 18:51:44 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:28064 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760729AbYGBWvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 18:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u0JL96IfMqm4D5+x5JhJWzfJ5ieUERQhhIdzSCgORq71xwdbRGqwqgkyaLpaq3lqu0
         LOQRb452ossnxTOqPY60jGawC8EmyEjz7f0XRLZlFSLLWvdC/js6cD1L3ZR+iDPPFG/m
         cvZ1ruoV5g2NU1psmN8H27xpRWwL0z6m8wj+M=
Message-ID: <29495f1d0807021551l1c934e68o3471105170ea0334@mail.gmail.com>
Date: Wed, 2 Jul 2008 15:51:35 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Eric Paris" <eparis@redhat.com>
Subject: Re: [PATCH] Hugetlb: stop race when reading proc meminfo
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org, agl@us.ibm.com
In-Reply-To: <1213899342.16752.39.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213899342.16752.39.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/08, Eric Paris <eparis@redhat.com> wrote:
> minor nit that hugetlb_report_{,node_}meminfo() does not lock the
>  reading of nr_huge_pages, free_huge_pages, and friends so this is not an
>  atomic set of information put into the buffer.  If /proc/meminfo is read
>  while the number of hugetlb pages is in flux it is possible to get
>  incorrect output such as:
>
>  HugePages_Total:     7
>  HugePages_Free:      8
>  HugePages_Rsvd:      0
>  Hugepagesize:     4096 kB
>
>  (test available at https://bugzilla.redhat.com/attachment.cgi?id=309864)
>
>  With the patch we beat on a number of boxes for hours with the above
>  test and saw no inconsistencies in the meminfo output.
>
>  Signed-off-by: Eric Paris <eparis@redhat.com>

While I understand the spirit of this patch, I'm not sure it's really
necessary. We've never bothered locking the output in the proc file
before because the information is inherently racy. It only gives you a
view of what was...if any application tries to make a decision based
upon that information (unless it has global control of the system, or
is a testcase, arguably), then it is already racy -- that is, the
numbers you read at one point in time have no bearing on whether those
pages will actually be free/available, etc when you actually need
them.

That being said, I don't feel to strongly about it. Just seems like it
might be unnecessary for an interface we know not to be fully accurate
to begin with, but maybe consistency is worth a bit of extra locking.

That actually also leads me to wonder if maybe the locking is not
there currently to avoid letting readers of proc files from blocking
users of hugepages?

Thanks,
Nish
