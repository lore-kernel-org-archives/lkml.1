Return-Path: <linux-kernel-owner+w=401wt.eu-S1762650AbYBHRYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbYBHRYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759476AbYBHRXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:23:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37713 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202AbYBHRXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:23:52 -0500
Date: Fri, 8 Feb 2008 17:23:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rth@redhat.com
Subject: Re: [PATCH] reduce large do_mount stack usage with noinlines
Message-ID: <20080208172337.GE27894@ZenIV.linux.org.uk>
References: <47AA3126.8090102@redhat.com> <20080206143457.03e8741d.akpm@linux-foundation.org> <47AA3EAA.9080204@redhat.com> <20080206152239.a2352d6d.akpm@linux-foundation.org> <p73myqb2y09.fsf@bingen.suse.de> <47AC8931.50704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AC8931.50704@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 10:54:09AM -0600, Eric Sandeen wrote:

> On gcc 4.1.2 and 4.3 (fedora flavors) I don't see it re-used in
> do_mount, though... *shrug*

Frankly, a wrapper for path_lookup() that would take struct path *,
refuse to do LOOKUP_PARENT (i.e. guaranteed to have nothing stored
in nameidata other than ->mnt and ->dentry) and copied result of
lookup into passed struct path * would help a lot more.

Taking it to fs/namei.c would prevent inlining just fine and we'd
be left with pair of pointers in caller's stack frame instead of
full struct nameidata.  All users in fs/namespace.c can be trivially
converted to that and AFAICS it would save a lot more than we would
get from making everything in there not inlined.

I'll do that in fs/namei.c sanitizing series (opens as soon as ro-bind
stuff goes in).
