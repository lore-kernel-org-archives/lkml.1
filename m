Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZGWQDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZGWQDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 12:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbZGWQDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 12:03:40 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41493 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbZGWQDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 12:03:40 -0400
Subject: Re: [RFC][PATCH] flexible array implementation v3
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: akpm@linux-foundation.org, vda.linux@googlemail.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       menage@google.com
In-Reply-To: <4A68855C.1060702@cs.columbia.edu>
References: <20090722175345.7154C2F2@kernel>
	 <4A68855C.1060702@cs.columbia.edu>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 09:02:17 -0700
Message-Id: <1248364937.24021.725.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-23 at 11:44 -0400, Oren Laadan wrote:
> Probably premature, but -- I wonder if it's worth adding interfaces to:
> 
> * copy a range of elements at once (perhaps to/from regular array ?
> or userspace ? -- depending on potential users)

I can see this making some sense, especially if you're dumping a bunch
of stuff out to userspace and don't want to worry about page boundaries,
etc...  Or, if you have a ton of stuff to copy and some of the
flex_array overhead is getting in the way.  I'm not opposed to it, but I
think I'd want to see a user first to make sure I got the implementation
right.

> * (macro ?) iterate through elements (better have it ready for users
> of flex_array before, than convert their code later on)

I've thought about this, but I don't think there's much advantage to
doing it.  It obfuscates things without any real gain in simplicity.  We
have LIST_FOR_EACH() because containerof() and some of the typing is a
little non-obvious.  But, here, I think it's mostly dummy-proof:

We need a 'tmp' variable here because unlike list traversal, there's no
position implied in the variables.  So, we're looking at (with a new
macro):

	int tmp;
	FA_FOR_EACH(fa, var, tmp)
		foo(var);

vs.

	int i;
	for (i = 0; i < fa->total_nr_elements; i++)
		foo(flex_array_get(fa, i));

The macro *looks* cleaner, but I don't think it really buys us much.

-- Dave

