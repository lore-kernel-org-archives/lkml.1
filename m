Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZKJOzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZKJOzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbZKJOzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:55:33 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:64848 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbZKJOz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:55:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=qToQ3HBcJcpI9Z3Gvh/6gOIVEIl2xdfd8cFcLUH9R/l+gRhKTuXaXp7Nc1mYMN9QWt
         wNnEUpqzhzoBojVPXWaU5l0KIocfD8o1qyForHqpI5RGzQ/TYSssgfoc4nBkDNlHTcaK
         tT38nzV7zW+iaYxO0yHWtQ32aOE5kAcD6hC00=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: tabbott@ksplice.com, alan-jenkins@tuffmail.co.uk, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v2 2/2] bsearch: prevent overflow when computing middle comparison element
Date: Mon,  9 Nov 2009 12:53:49 -0200
Message-Id: <d748022cff75d9c09afc93b77cb16a683136cd13.1257778258.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.2.153.g6e31f.dirty
In-Reply-To: <cover.1257778258.git.andre.goddard@gmail.com>
References: <cover.1257778258.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's really difficult to occur in practice because the sum of the lower
and higher limits must overflow an int variable, but it can occur when
working with large arrays. We'd better safe than sorry by avoiding this
overflow situation when computing the middle element for comparison.

See:
http://googleresearch.blogspot.com/2006/06/extra-extra-read-all-about-it-nearly.html
http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=5045582

The program below demonstrates the issue:

$ ./a.out
(glibc)         Element is at the last position
(patched)       Element is at the last position
Segmentation fault

===
#include <search.h>
#include <stdlib.h>
#include <stdio.h>

/* A number that when doubled will be bigger than 2^31 - 1 */
#define BIG_NUMBER_TO_OVERFLOW_INT	(1100000000)

static int cmp_char(const void *p1, const void *p2)
{
	char v1 = (*(char *)p1);
	char v2 = (*(char *)p2);

	if (v1 < v2)
		return -1;
	else if (v1 > v2)
		return 1;
	else
		return 0;
}

void *lib_bsearch(const void *key, const void *base, size_t num, size_t size
	, int (*cmp)(const void *key, const void *elt))
{
	int start = 0, end = num - 1, mid, result;

	while (start <= end) {
		mid = (start + end) / 2;
		result = cmp(key, base + mid * size);
		if (result < 0)
			end = mid - 1;
		else if (result > 0)
			start = mid + 1;
		else
			return (void *)base + mid * size;
	}

	return NULL;
}

void *patch_lib_bsearch(const void *key, const void *base, size_t num, size_t size
	, int (*cmp)(const void *key, const void *elt))
{
	size_t start = 0, end = num, mid;
	int result;

	while (start < end) {
		mid = (start + end) / 2;
		result = cmp(key, base + mid * size);
		if (result < 0)
			end = mid - 1;
		else if (result > 0)
			start = mid + 1;
		else
			return (void *)base + mid * size;
	}

	return NULL;
}

int main(void)
{
	char key = 1;
	char *array = calloc(BIG_NUMBER_TO_OVERFLOW_INT, sizeof(char));
	void *ptr;

	if (!array)
	{
		printf("%s\n", "no memory");
		return EXIT_FAILURE;
	}
	array[BIG_NUMBER_TO_OVERFLOW_INT - 1] = 1;

	ptr = bsearch(&key, array, BIG_NUMBER_TO_OVERFLOW_INT, sizeof(char), cmp_char);
	printf("(glibc) Element is%sat the last position\n"
		, (ptr == &array[BIG_NUMBER_TO_OVERFLOW_INT - 1]) ? " " : " NOT ");

	ptr = patch_lib_bsearch(&key, array, BIG_NUMBER_TO_OVERFLOW_INT, sizeof(char), cmp_char);
	printf("(patched) Element is%sat the last position\n"
		, (ptr == &array[BIG_NUMBER_TO_OVERFLOW_INT - 1]) ? " " : " NOT ");

	ptr = lib_bsearch(&key, array, BIG_NUMBER_TO_OVERFLOW_INT, sizeof(char), cmp_char);
	printf("(unpatched) Element is%sat the last position\n"
		, (ptr == &array[BIG_NUMBER_TO_OVERFLOW_INT - 1]) ? " " : " NOT ");

	free(array);

	return EXIT_SUCCESS;
}

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 lib/bsearch.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/bsearch.c b/lib/bsearch.c
index 33cbba6..af40c03 100644
--- a/lib/bsearch.c
+++ b/lib/bsearch.c
@@ -33,7 +33,8 @@
 void *bsearch(const void *key, const void *base, size_t num, size_t size,
 	      int (*cmp)(const void *key, const void *elt))
 {
-	int start = 0, end = num, mid, result;
+	size_t start = 0, end = num, mid;
+	int result;
 
 	while (start < end) {
 		mid = (start + end) / 2;
-- 
1.6.5.2.153.g6e31f.dirty

