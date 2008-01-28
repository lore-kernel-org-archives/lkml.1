Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbYA1Bnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbYA1Bnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 20:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYA1BnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 20:43:25 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:29024 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751540AbYA1BnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 20:43:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=ZvDMgTc1V+KtRcHZTxR1V0NHXWVcDmnYfG+U7Xq3UqKTxxFZNN+CU+zFcrG1lyVxpsQNw1XexObzd8Tnabv5ziRGFcp4DZip2dtz9RJbXJAMS2i6J2oKMPTA3tij3VRNlSS5eqgJzCehK2JlEg0zUyE7hKYaUGSjnI+WBqZ3QhM=  ;
X-YMail-OSG: 9XyjX.oVM1lipxTCC21P_BlHrT8kHx8qFfRQIkQWP6343rI1ccfrb7NPDDSo6VoqBQTQCmv8.A--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] some page can't be migrated
Date: Mon, 28 Jan 2008 12:43:08 +1100
User-Agent: KMail/1.9.5
Cc: Shaohua Li <shaohua.li@intel.com>, clameter@sgi.com,
       linux-kernel@vger.kernel.org
References: <1201069357.32059.13.camel@sli10-desk.sh.intel.com> <1201241005.24290.5.camel@sli10-desk.sh.intel.com> <20080126220351.a04819f9.akpm@linux-foundation.org>
In-Reply-To: <20080126220351.a04819f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801281243.08849.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008 17:03, Andrew Morton wrote:
> > On Fri, 25 Jan 2008 14:03:25 +0800 Shaohua Li <shaohua.li@intel.com>
> > wrote:
> >
> > -	if (!page->mapping)
> > +	if (!page->mapping) {
> > +		if (!PageAnon(page) && PagePrivate(page))
> > +			try_to_release_page(page, GFP_KERNEL);
> >  		goto rcu_unlock;
> > +	}
>
> We call something(GFP_KERNEL) under rcu_read_lock()?  I've lost track of
> the myriad flavours of rcu which we purport to support, but I don't think
> they'll all like us blocking under rcu_read_lock().
>
> We _won't_ block, because try_to_release_page() will see the NULL ->mapping
> and will call the non-blocking try_to_free_buffers().  But still, it looks
> bad, and will cause problems if someone decides to add a might_sleep_if()
> to try_to_release_page().
>
> So...  I'd suggest that it would be better to add an apologetic comment and
> call direct into try_to_free_buffers().

You're right, but can't we just rcu_read_unlock() before try_to_release_page?
