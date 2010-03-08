Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab0CHV55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:57:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44971 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab0CHV5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:57:54 -0500
Date: Mon, 8 Mar 2010 21:57:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] notification: after one week
Message-ID: <20100308215748.GO30031@ZenIV.linux.org.uk>
References: <1268081739.3227.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268081739.3227.5.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 03:55:39PM -0500, Eric Paris wrote:
> Having you tell me to wait a week after rebasing (and probably being the
> only person who waited a week after rebasing to ask for a pull) I'm
> back.  I hoped to hear some review but none came.  If it does, rest
> assured addressing those issues will be my top priority.  Since the last
> pull request the only change is that I corrected the build flags to not
> add -Wsigned-pointer and I actually dropped the permissions bits from
> this branch (those bits are and have been in linux-next for a long time
> now as well though)

Sigh...  I *will* dig the full review out (been buried in autofs review
lately), but for starters grep for fsnotify() and fsnotify_parent(),
then tell me why on the earth are you doing that kind of insane multiplexors?

I mean, WTF?
; git grep -n -w fsnotify_parent
include/linux/fsnotify.h:28:static inline void fsnotify_parent(struct path *path, struct dentry
include/linux/fsnotify.h:115:   fsnotify_parent(NULL, dentry, mask);
include/linux/fsnotify.h:176:           fsnotify_parent(path, NULL, mask);
include/linux/fsnotify.h:194:           fsnotify_parent(path, NULL, mask);
include/linux/fsnotify.h:212:           fsnotify_parent(path, NULL, mask);
include/linux/fsnotify.h:231:           fsnotify_parent(path, NULL, mask);
include/linux/fsnotify.h:247:   fsnotify_parent(NULL, dentry, mask);
include/linux/fsnotify.h:282:           fsnotify_parent(NULL, dentry, mask);
;

and *ALL* callers get one of those NULL and another non-NULL.  With
different behaviour inside that sucker.  And fsnotify() is no better -
it's a multiplexor from hell.
