Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbYGYSZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbYGYSZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYGYSZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:25:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43814 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYGYSZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:25:13 -0400
Date: Fri, 25 Jul 2008 19:25:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Steve French <smfrench@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cifs: avoid mixing bool and le16
Message-ID: <20080725182510.GL28946@ZenIV.linux.org.uk>
References: <1216857138.30386.33.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216857138.30386.33.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 04:52:18PM -0700, Harvey Harrison wrote:
> fs/cifs/cifssmb.c:3917:13: warning: incorrect type in assignment (different base types)
> fs/cifs/cifssmb.c:3917:13:    expected bool [unsigned] [usertype] is_unicode
> fs/cifs/cifssmb.c:3917:13:    got restricted __le16
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

It's a sparse bug - the thing doesn't treat conversions to bool right.

FWIW, if you want an obviously broken case, consider

char a[2 * (bool)2 - 1];

It *should* turn into

char a[1];

What happens instead is that bool is treated as 1-bit unsigned integer
type, resulting in char a[-1].

So we need to fix that crap; the real rules are simple - conversion of
any arithmetic or pointer type to _Bool behaves as if we had v != 0;
same as for if/while/do/for conditions.
