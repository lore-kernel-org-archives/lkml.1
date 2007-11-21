Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbXKUDLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbXKUDLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 22:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbXKUDLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 22:11:34 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:12554 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbXKUDLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 22:11:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZRK2Xw6+2yK0/awn+jS1NgtLQg1HrIu0st6aGocEtkftgZEoXXIIXNUZ0wQfrKY8xRgFhe+vkTxy7JOE7fLz8vHRNimBFtLYXZo6EHNdchyOnBkK7wOyvBcdvK93995Z+hE5e5U2W+07je+8zVnBnHkWWEHV5X5C89VWmSS6C54=
Message-ID: <118833cc0711201911r3684937p38823649639e0a57@mail.gmail.com>
Date: Tue, 20 Nov 2007 22:11:31 -0500
From: "Morten Welinder" <mwelinder@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Inotify fails to send IN_ATTRIB events
Cc: rlove@rlove.org, "Linus Torvalds" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing missing inotify IN_ATTRIB events in the following situation:

1. "touch foo"

2. Make inotify watch "foo"

3. "ln foo bar"
   --> Link count changed so I should have gotten an IN_ATTRIB.

4. "rm foo"
   --> Link count changed so I should have gotten an IN_ATTRIB.  (Or
IN_DELETE_SELF;
   I don't care which.)

5. "ln bar foo && rm bar"
   --> Still no events.

6. "mv foo bar"
   --> I get IN_MOVED_SELF.  Good!

7. "mv bar foo"
   --> I get IN_MOVED_SELF.  Good!


3+4 is pretty much the same as 6, so I really ought to be told that my
file has changed
name.  I don't really care much about getting notified about 3, but
for completeness
it ought to be handled.

As far as I can see, the only way to be told about 4 is to put a watch
on the directory in
which foo resides.  That is inelegant and has an inherent race condition.

This is with "Linux version 2.6.22.12-0.1-default" (SuSE 10.3)

Looking at current source, fs/namei.c, I notice that vfs_rename has a
fsnotify_move call
(which notified directory as well as files) whereas sys_link only has
a fsnotify_create call
(which notified the directory only).

Morten
