Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbXJXCTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbXJXCTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbXJXCTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:19:08 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:47556 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbXJXCTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:19:07 -0400
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Matthew Wilcox <matthew@wil.cx>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <1193173966-3550-1-git-send-email-matthew@wil.cx>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 22:19:06 -0400
Message-Id: <1193192346.8691.36.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-23 at 17:12 -0400, Matthew Wilcox wrote:
> Consecutive calls to printk are non-atomic, which leads to various
> implementations for accumulating strings which can be printed in one call.
> This is a generic string buffer which can also be used for non-printk
> purposes.  There is no sb_scanf implementation yet as I haven't identified
> a user for it.
> 
> +
> +struct stringbuf {
> +	char *s;
> +	int alloc;
> +	int len;
> +};
> +

I don't know if copy-on-write semantics are really useful for current
in-kernel uses, but I've coded and used a C++ string class like this in
the past:

struct string_data
{
	int nrefs;
	unsigned len;
	unsigned capacity;
	//char data[capacity];	/* allocated along string_data */
};

struct string	/* or typedef in C... */
{
	struct string *data;
};

[ struct string_data is a hidden implementation detail, only struct
string is exposed ]

Multiple string objects can share the same data, by increasing the nrefs
count, a new data is allocated if the string is modified and nrefs > 1.

Not having to iterate over the string to calculate it's length,
allocating a larger buffer to eliminate re-allocation and copy-on-write
semantics make a string like this a vast performance improvement over a
normal C string for a minimal (about 3 ints per data buffer) memory
cost.

By using it correctly it can prevents buffer overflows.

You still always null terminate the string stored in data to directly
use it a normal C string.

You also statically allocate an empty string which is shared by all
"uninitialized" or empty strings.


Even without copy-on-write semantics and reference counting, I think
this approach is better because it uses 1 less "object" and allocation:

struct string - "handle" (pointer really) to string data
struct string_data - string data

versus:

struct stringbuf *sb - pointer to string object
struct stringbuf - string object
char *s (member of stringbuf) - string data



Best regards,

- Eric


