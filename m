Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYEPOcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYEPOcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYEPOcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:32:12 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1965 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750904AbYEPOcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:32:11 -0400
Date: Fri, 16 May 2008 10:32:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Bryan Wu <cooloney@kernel.org>, Jie Zhang <jie.zhang@analog.com>,
       Oliver Neukum <oliver@neukum.org>, <david-b@pacbell.net>,
       <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb: file-storage.c use unaligned access helpers
In-Reply-To: <1210897985.5915.19.camel@brick>
Message-ID: <Pine.LNX.4.44L0.0805161021450.25035-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Harvey Harrison wrote:

> Replace the put_be16/32 and get_be16/32 helpers with the
> common unaligned access routines.  Note that these put_ helpers
> had the pointer/value parameter in the opposite order from the
> common version.

This is fine and it's what I requested.  Still, it's not really the 
best solution.

In many of the places where these helpers are used, we _know_ that the
buffers are in fact aligned properly.  For example, in code like this:

> -			put_be16(&buf[4], 0xffff);
> +			put_unaligned_be16(0xffff, &buf[4]);

we know that buf is aligned.  It would be great if there were helpers 
which would allow us to do

			put_be16(&buf[4], 0xffff);

instead of

			* (__be16 *) &buf[4] = cpu_to_be16(0xffff);

They could also be used to clean up the disputed HCD code.  Is this a
reasonable thing to ask for?  A few simple, arch-independent macros
would be sufficient.

Alan Stern

