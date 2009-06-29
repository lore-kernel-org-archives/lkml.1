Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbZF2V6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbZF2V6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 17:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbZF2V6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 17:58:30 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:63526 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbZF2V6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 17:58:30 -0400
MIME-Version: 1.0
Message-ID: <a2cac9b3-74c1-4eea-8273-afe2226cef1d@default>
Date: Mon, 29 Jun 2009 14:57:23 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, npiggin@suse.de, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com,
       Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
       alan@lxorguk.ukuu.org.uk, Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org,
       Himanshu Raj <rhim@microsoft.com>
Subject: RE: [RFC] transcendent memory for Linux
In-Reply-To: <4A4930DA.5030700@goop.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A4938D9.01B6:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jeremy Fitzhardinge [mailto:jeremy@goop.org]
> 
> On 06/29/09 14:13, Dan Magenheimer wrote:
> > The uuid is only used for shared pools.  If two different
> > "tmem clients" (guests) agree on a 128-bit "shared secret",
> > they can share a tmem pool.  For ocfs2, the 128-bit uuid in
> > the on-disk superblock is used for this purpose to implement
> > shared precache.  (Pages evicted by one cluster node
> > can be used by another cluster node that co-resides on
> > the same physical system.) 
> 
> What are the implications of some third party VM guessing the 
> "uuid" of
> a shared pool?  Presumably they could view and modify the contents of
> the pool.  Is there any security model beyond making UUIDs 
> unguessable?

Interesting question.  But, more than the 128-bit UUID must
be guessed... a valid 64-bit object id and a valid 32-bit
page index must also be guessed (though most instances of
the page index are small numbers so easy to guess).  Once
192 bits are guessed though, yes, the pages could be viewed
and modified.  I suspect there are much more easily targeted
security holes in most data centers than guessing 192 (or
even 128) bits.

Now this only affects shared pools, and shared-precache is still
experimental and not really part of this patchset.  Does "mount"
of an accessible disk/filesystem have a better security model?
Perhaps there are opportunities to leverage that?

> > The (page)size argument is always fixed (at PAGE_SIZE) for
> > any given kernel.  The underlying implementation can
> > be capable of supporting multiple pagesizes.
>
> Pavel's other point was that merging the size field into the 
> flags is a
> bit unusual/ugly.  But you can workaround that by just defining the
> "flag" values for each plausible page size, since there's a 
> pretty small
> bound: TMEM_PAGESZ_4K, 8K, etc.

OK I see.  Yes the point (and the workaround) are valid.
 
> Also, having an "API version number" is a very bad idea.  Such version
> numbers are very inflexible and basically don't work (esp if you're
> expecting to have multiple independent implementations of this API). 
> Much better is to have feature flags; the caller asks for features on
> the new pool, and pool creation either succeeds or doesn't (a call to
> return the set of supported features is a good compliment).

Yes.  Perhaps all the non-flag bits should just be reserved for
future use.  Today, the implementation just checks for (and implements)
only zero anyway and nothing is defined anywhere except the 4K
pagesize at the lowest levels of the (currently xen-only) API.

Thanks,
Dan
