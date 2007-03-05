Return-Path: <linux-kernel-owner+w=401wt.eu-S933644AbXCEVnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbXCEVnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933457AbXCEVns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:43:48 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37719 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933648AbXCEVnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:43:47 -0500
Date: Mon, 5 Mar 2007 13:43:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Will Trives <will@trivescon.com.au>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH] fs: nobh_truncate_page() fix
In-Reply-To: <1173128289.9109.36.camel@kleikamp.austin.ibm.com>
Message-ID: <Pine.LNX.4.64.0703051333140.3998@woody.linux-foundation.org>
References: <20070305150317.57e62d70@disher.kickcrew>  <45EC3058.2010903@redhat.com>
  <1173108985.9109.11.camel@kleikamp.austin.ibm.com> 
 <1173109811.9109.17.camel@kleikamp.austin.ibm.com>
 <1173128289.9109.36.camel@kleikamp.austin.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Mar 2007, Dave Kleikamp wrote:
> 
> This fixes a regression caused by 22c8ca78f20724676b6006232bf06cc3e9299539.
> 
> nobh_prepare_write() no longer marks the page uptodate, so
> nobh_truncate_page() needs to do it.

I'm not convinced...

If the page wasn't up-to-date from before, it's *not* necessarily 
up-to-date after the truncate either! So why do we have that at all?

The same comment is true of "nobh_commit_write()" (which _does_ have the 
SetPageUptodate() there).

So I have three questions:

 - why is that valid in the first place (the page is *not* guaranteed to 
   be up-to-date as far as I can see!)

 - why is it valid to do in "nobh_commit_write()"

 - why doesn't "nobh_truncate_page()"
	(a) call nobh_prepare_write() through an indirect pointer?
	(b) call nobh_commit_write() at all? (Yeah, I realize it's because 
	    of brokenness with i_size, so this is more of a "those 
	    functions should be factored out properly" statement rather 
	    than a question.

IOW, I'm sure your patch _fixes_ something, but no, it's certainly not 
obvious to me. A few added comments would be good.. Why is it ok to do 
this on a page that wasn't up-to-date before (since obviously, if it *was* 
up-to-date, it's pointless).

		Linus
