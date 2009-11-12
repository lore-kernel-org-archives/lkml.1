Return-Path: <linux-kernel-owner+w=401wt.eu-S1752231AbZKLNGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbZKLNGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 08:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZKLNGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 08:06:13 -0500
Received: from ozlabs.org ([203.10.76.45]:40276 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbZKLNGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 08:06:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?utf-8?q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>
Subject: Re: [PATCH v4 2/2] bsearch: prevent overflow when computing middle comparison element
Date: Thu, 12 Nov 2009 23:36:10 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: tabbott@ksplice.com, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org
References: <cover.1257864802.git.andre.goddard@gmail.com> <2bd27b061789ed14dd80816fd987273ae33ffbd1.1257864802.git.andre.goddard@gmail.com>
In-Reply-To: <2bd27b061789ed14dd80816fd987273ae33ffbd1.1257864802.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911122336.11033.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 01:30:25 am André Goddard Rosa wrote:
> It's really difficult to occur in practice because the sum of the lower
> and higher limits must overflow an int variable, but it can occur when
> working with large arrays. We'd better safe than sorry by avoiding this
> overflow situation when computing the middle element for comparison.

I applied all these, after testing.  In future would have been nice for you
to have posted a test patch so I didn't have make my own...

Thanks,
Rusty.

diff --git a/lib/bsearch.c b/lib/bsearch.c
--- a/lib/bsearch.c
+++ b/lib/bsearch.c
@@ -51,3 +51,50 @@ void *bsearch(const void *key, const voi
 	return NULL;
 }
 EXPORT_SYMBOL(bsearch);
+
+#if 1
+static int test_cmp(const void *_key, const void *_elt)
+{
+	int key = *(int *)_key, elt = *(int *)_elt;
+
+	if (key < elt)
+		return -1;
+	else if (key > elt)
+		return 1;
+	return 0;
+}
+
+static int test_bsearch(void)
+{
+	const int arr[] = { INT_MIN, 0, 1, 2, 3, 4, 5, 6, INT_MAX };
+	unsigned int start, num, i, total = 0;
+	int key;
+
+	for (start = 0; start < ARRAY_SIZE(arr); start++) {
+		for (num = 0; num < ARRAY_SIZE(arr) - start; num++) {
+			key = 7;
+			BUG_ON(bsearch(&key, &arr[start], num, sizeof(arr[0]),
+				       test_cmp));
+			total++;
+			for (i = start; i < start+num; i++) {
+				int *ret;
+				key = arr[i];
+				ret = bsearch(&key, &arr[start], num,
+					      sizeof(arr[0]), test_cmp);
+				if (!ret) {
+					printk("Could not find %i in %u-%u"
+					       "(between %i and %i)\n",
+					       key, start, start+num,
+					       arr[start], arr[start+num]);
+				}
+				BUG_ON(!ret);
+				BUG_ON(*ret != key);
+				total++;
+			}
+		}
+	}
+	printk("Tested %u bsearches\n", total);
+	return 0;
+}
+module_init(test_bsearch);
+#endif
