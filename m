Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZFXEil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZFXEil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 00:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZFXEid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 00:38:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44276 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZFXEid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 00:38:33 -0400
Date: Wed, 24 Jun 2009 05:38:35 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] asm-generic: uaccess: do not expand args multiple
	times
Message-ID: <20090624043835.GM8633@ZenIV.linux.org.uk>
References: <1244959204-11269-1-git-send-email-vapier@gentoo.org> <200906142214.40532.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906142214.40532.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 10:14:39PM +0200, Arnd Bergmann wrote:
> On Sunday 14 June 2009, Mike Frysinger wrote:
> > While it's debatable whether {get,put}_user() should be called with
> > arguments that have side effects, macro's should be written safely in the
> > first place.  In this case, a slightly off version of put_user() ended up
> > causing random userspace corruption and these things aren't trivial to
> > track down.
> > 
> > While some of these conversions aren't strictly necessary, I think it's
> > better to do all of them so as to be proactive in people accidently
> > screwing it up in the future.
> 
> I've tried this and failed. This change adds an endless number of sparse
> warnings in put_user and even gcc warnings in get_user. The problem
> is that typeof() carries over the 'const' and '__user' modifiers, both
> of which prevent you from assigning data to the new pointer that you
> constructed.
> 
> I'd love to see a way to do this correctly, but this patch won't cut it.

Note that sizeof(*(ptr)) does *NOT* evaluate ptr, unless we are dealing
with variably-modified type.  The same goes for typeof.  And chk_user_ptr()
expands to (void)0 during the build.  So I don't believe that existing variant
is incorrect - we do not evaluate the argument twice.
