Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbZCER0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbZCER0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 12:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZCER03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 12:26:29 -0500
Received: from c60.cesmail.net ([216.154.195.49]:27098 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766AbZCER02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 12:26:28 -0500
Subject: Re: [Orinoco-users] linux-firmware binary corruption with gitweb
From: Pavel Roskin <proski@gnu.org>
To: Dave <kilroyd@googlemail.com>
Cc: Jakub Narebski <jnareb@gmail.com>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org, orinoco-users@lists.sourceforge.net,
       dwmw2@infradead.org, "John 'Warthog9' Hawley" <warthog9@eaglescrag.net>
In-Reply-To: <49AF1429.9080009@gmail.com>
References: <49A98F6A.50702@gmail.com> <1235886467.3195.15.camel@mj>
	 <49AD7E2B.3010101@gmail.com> <m3iqmqt9ox.fsf@localhost.localdomain>
	 <49AF1429.9080009@gmail.com>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 12:26:21 -0500
Message-Id: <1236273981.24072.16.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 23:52 +0000, Dave wrote:
>         binmode STDOUT, ':raw';
> -        print <$fd>;
> +        #print <$fd>;
> +        $output .= <$fd>;
>         binmode STDOUT, ':utf8'; # as set at the beginning of
> gitweb.cgi

Nice catch!

Looking at the gitweb repository from kernel.org, two instances of
circumventing binmode were introduced by this commit:

commit c79ae555fb3c89d91b4cafbfce306e695720507b
Author: John Hawley <warthog9@voot-cruiser.localdomain>
Date:   Thu Dec 28 21:59:43 2006 -0800

    Last of the changes to deal with channeling the text through the caching
    engine.  Wow is this a total hack.

The original behavior was restored in git_snapshot() by the recent
commit c15229acd9bedf165f1eb05d99fa989d3b9f3e32, but git_blob_plain()
remains broken.

I don't see an easy fix.  We cannot manipulate the blob to counteract
the encoding, as it may not be valid utf-8, and therefore won't be
output in the utf-8 mode.

Maybe binmode should be raw everywhere, and adding to $output should
recode data to utf-8 from other encodings where needed, but it would be
a massive patch, I'm afraid.  Or it would be a small patch requiring
massive testing.

Adding John Hawley to cc:

-- 
Regards,
Pavel Roskin
