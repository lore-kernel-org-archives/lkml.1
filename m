Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbZDOVtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbZDOVtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbZDOVtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:49:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37831 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbZDOVtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:49:36 -0400
Subject: How SHOULD inotify and hardlinks play together?
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, john@johnmccutchan.com, rlove@rlove.org,
       viro@zeniv.linux.org.uk
Content-Type: text/plain
Date: Wed, 15 Apr 2009 17:49:08 -0400
Message-Id: <1239832148.2562.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

touch /tmp/file1 /tmp/file2
ln /tmp/file2 /tmp/hardlinktofile2

[A] Set up one inotify watch on /tmp/file2
[B] Set up another inotify watch on /tmp/hardlinktofile2

(they are both watching the same inode/data)

mv /tmp/file1 /tmp/file2

Right now, today, both [A] and [B] are going to get DELETE_SELF and
IGNORED messages and are not going to get any more notifications.

That might be fine for [A] since the pathname it ask to watch doesn't
exist any more (although I argue the inode still does), but that isn't
right for [B] since /tmp/hardlinktofile2 is still there, still it's own
inode, and still able to receive events, be modified, be read, be
deleted, whatever.  But after that mv operation neither [A] nor [B] will
get any more events what-so-ever.

So the question is, should inotify continue to clear all watches on an
inode when something else is moved on top if it even if i_nlink isn't
going to 0?  If not, should inotify continue to send a DELETE_SELF like
it does today?  Should it instead send an ATTRIB like it does when you
add a hard link?

-Eric

