Return-Path: <linux-kernel-owner+w=401wt.eu-S1759971AbYBTJ5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971AbYBTJ5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbYBTJ4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:56:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55429 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439AbYBTJ4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:56:50 -0500
Date: Wed, 20 Feb 2008 01:55:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       michael@free-electrons.com
Subject: Re: 2.6.25-rc2-mm1 (x64 thermal build failure)
Message-Id: <20080220015534.c62f2e56.akpm@linux-foundation.org>
In-Reply-To: <20080220082133.56f93d27@crazy>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080216211603.bb4f3582.randy.dunlap@oracle.com>
	<20080216214410.b9699910.akpm@linux-foundation.org>
	<20080218111536.511c4fbc@crazy>
	<20080218041340.f1e46ec9.akpm@linux-foundation.org>
	<20080219165502.2c202759@crazy>
	<20080219152129.6e8b7956.akpm@linux-foundation.org>
	<20080220082133.56f93d27@crazy>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 08:21:33 +0100 Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> Le Tue, 19 Feb 2008 15:21:29 -0800,
> Andrew Morton <akpm@linux-foundation.org> a __crit :
> 
> > ug, sorry, if I'd realised it was like this I'd have said "don't
> > bother". Apart from the obvious problem, this means that people will
> > keep breaking CONFIG_DMI=n all the time, because they will forget the
> > ifdefs, and the number of people who test with CONFIG_DMI=n will be
> > small.
> 
> Yes, #ifdef CONFIG_DMI is not very comfortable. That why I proposed
> things such as DECLARE_DMI_FIXUP_TABLE(), because it would force people
> to use these macros, which would then be working correctly depending on
> DMI=y/n. However, there's still the issue of driver_data that I
> mentionned in my earlier post.
> 
> What should I do ? Option 1 ? Option 2 ? Give up with the patch ?
> 
> Thanks for your comments,

Option 1 would be best, I think:

 1) Remove the #ifdef CONFIG_DMI around DMI fixup tables and callbacks
    definition, so that everything exists and gcc is happy. gcc is able
    to optimize out the DMI fixup table (it is not present in the binary
    when compiling with DMI=n), but gcc doesn't seem to be able to
    optimize out the DMI fixup callbacks (they are still present in the
    binary). So this would leave some unused code in the binary, which
    is not completely satisfying.

gcc _should_ be able to remove the callbacks as long as they are static and
have no references.  If even the latest gcc versions are still incluing the
unreferenced, static function in the final vmlinux then let's get gcc fixed?

