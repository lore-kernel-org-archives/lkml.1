Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZHZLZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZHZLZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbZHZLZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:25:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599AbZHZLZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:25:23 -0400
Subject: Re: v2.6.31-rc6 inotify not reporting deleted files
From: Eric Paris <eparis@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <m1skffj64t.fsf@fess.ebiederm.org>
References: <m1skffj64t.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 07:25:04 -0400
Message-Id: <1251285904.2270.22.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 02:06 -0700, Eric W. Biederman wrote:
> I don't have a small test case yet, but I have an application that
> uses inotify and watches a file and takes action when that file has been
> deleted.  Running that application on 2.6.31-rc6 the application is
> no longer seeing the file being deleted.
> 
> With luck a word to the wise is all that is required for you to reproduce
> this.  Otherwise I will spend some time tomorrow making a small reproducer.

I'm probably going to need a little more to go on.  The most simple
tests seem to work for me...

kernel-2.6.31-0.167.rc6.git6.fc12.x86_64

Watch /tmp/ while deleting /tmp/tmp:
$ touch /tmp/tmp
$ inotifywait -m /tmp
Setting up watches.  
Watches established.
/tmp/ DELETE tmp
^C

Watch /tmp/tmp while deleting /tmp/tmp
$ touch /tmp/tmp
$ inotifywait -m /tmp/tmp
Setting up watches.  
Watches established.
/tmp/tmp ATTRIB 
/tmp/tmp DELETE_SELF 
/tmp/tmp IGNORED

Delete 2 files while inotifywait is asleep
$touch /tmp/tmp1 /tmp/tmp2
$inotifywait -m /tmp
Setting up watches.  
Watches established.
^Z
[1]+  Stopped                 inotifywait -m /tmp
$ rm -f /tmp/tmp1
$ rm -f /tmp/tmp2
$ fg
inotifywait -m /tmp
/tmp/ DELETE tmp1
/tmp/ DELETE tmp2
^C

Delete 2 directories while inotifywait is asleep
$ mkdir /tmp/tmp1 /tmp/tmp2
$ inotifywait -m /tmp
Setting up watches.  
Watches established.
^Z
[1]+  Stopped                 inotifywait -m /tmp
$ rmdir /tmp/tmp1
$ rmdir /tmp/tmp2
$ fg
inotifywait -m /tmp
/tmp/ DELETE,ISDIR tmp1
/tmp/ DELETE,ISDIR tmp2

