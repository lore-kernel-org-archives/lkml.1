Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbYAEFSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbYAEFSe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 00:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbYAEFSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 00:18:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55006 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbYAEFSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 00:18:23 -0500
Date: Sat, 5 Jan 2008 05:18:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Knutsson <ricknu-0@student.ltu.se>,
       Mathieu Segaud <mathieu.segaud@regala.cx>, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
Message-ID: <20080105051817.GD27894@ZenIV.linux.org.uk>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx> <477E379F.4000103@student.ltu.se> <20080105041228.GP3351@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105041228.GP3351@webber.adilger.int>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 09:12:28PM -0700, Andreas Dilger wrote:

> What's wrong with __FUNCTION__?  I thought that was ANSI C?

__FUNCTION__ is a gccism of dubious taste - it pretends to be a macro
when it's something far out of scope of preprocessor.  Think for a minute
and you'll see why - you can't expand it until you are done with parsing.

__func__ is C99, but it's not what __FUNCTION__ used to be - it's not a
string literal.  6.4.2.2(1):

	The identifier __func__ shall be implicitly declared by the translator
as if, immediately following the opening brace of each function definition,
the declaration
	static const char __func__[] = "function-name";
appeared, where function-name is the name of the lexically-enclosing function.

IOW, it's a phase 7 (parsing and translation of translation units) and not
phase 4 (preprocessor).  Practical implications are:
	* _way_ fewer kludges
	* it happens after phase 6 (string literal concatenation)
So __FUNCION__ " is called" within body of foo() would result in
"foo is called" while __func__ "is called" is a syntax error.

These days old gcc __FUNCTION__ is gone; it's a macro expanding to __func__,
so behaviour does *not* match the original (see above).

The thing is, it's not something like __FILE__ or __LINE__ and never had been;
it tried to pretend that it had been like those but that required far too
nasty kludges and these days it is firmly in the "nothing to do with
preprocessor" land.  Old name is #defined to __func__ to approximate the
old behaviour, but it doesn't approximate it all that well and it's really
not fit for anything but backwards compatibility in legacy code.

BTW, we used to have code that broke when gcc abandoned the old kludge -
several years ago there'd been a pile of patches fixing the resulting
turds.
