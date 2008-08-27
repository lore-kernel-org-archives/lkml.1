Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbYH0LM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbYH0LM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbYH0LMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:12:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719AbYH0LMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:12:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1219788326.6069.40.camel@brick>
References: <1219788326.6069.40.camel@brick>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] afs: fsclient.c sparse endian annotations of operation_ID
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Wed, 27 Aug 2008 12:12:24 +0100
Message-ID: <28254.1219835544@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> wrote:

> +		if (call->operation_ID != __constant_htonl(FSFETCHDATA64)) {

Doesn't htonl() resolve to this for a constant argument?  Following through
the definitions, it certainly looks like it ought to:

	<linux/byteorder/generic.h>
	#undef htonl
	#define ___htonl(x) __cpu_to_be32(x)

	<linux/byteorder/little_endian.h>
	#define __cpu_to_be32(x) ((__force __be32)__swab32((x)))

	<linux/byteorder/swab.h>
	#  define __swab32(x) \
	(__builtin_constant_p((__u32)(x)) ? \
	 ___constant_swab32((x)) : \
	 __fswab32((x)))

at least for GCC with optimisation enabled.

Of course, linux/byteorder.h and linux/swab.h seem to do much the same.  Any
idea why we have both sets?  There seems to be unnecessary redundancy.

David
