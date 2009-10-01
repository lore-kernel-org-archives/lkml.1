Return-Path: <linux-kernel-owner+w=401wt.eu-S932624AbZJAOSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbZJAOSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932590AbZJAOSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:18:37 -0400
Received: from fifo99.com ([67.223.236.141]:60455 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473AbZJAOSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:18:35 -0400
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
From: Daniel Walker <dwalker@fifo99.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20090930152708.GD2957@shadowen.org>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	 <4AB86ED1.1040200@cn.fujitsu.com>  <20090930152708.GD2957@shadowen.org>
Content-Type: text/plain
Date: Thu, 01 Oct 2009 07:18:30 -0700
Message-Id: <1254406711.18167.88.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 16:27 +0100, Andy Whitcroft wrote:

> Yeah I think that blanket ignoring spacing throughout the file seems
> dangerous.  If these are going to show up a lot then it seems more sensible
> to special case TRACE_EVENT or whatever is triggering the actual 'false'
> matches.  I also suspect the 'this should never get long' argument will
> not be true.  Once you can have an exception people will add them all over

It's not ignoring all spacing .. It's just ignoring a single error in a
single directory (or single file).. So it's very specific.. If you did
just match TRACE_EVENT like you suggest then what happens when another
different call in the same code has similar spacing , which could easily
happen.. You also are basically matching a style defect, which doesn't
make much sense to me.. Then one day the person that added the errors
has a revelation , and removes all the errors. Then all the work that
went into the matching is poof worthless.. This list could get to be
10-20 items lots (still not that long) , and writing individual matching
for each of those items and maintaining it would be more work that is
necessary ..

In terms of the list getting long or not, your basically in control of
it since you maintain checkpatch .. If you leave it without some sort of
blacklist, then you end up with whole sections of code where the
developers don't use checkpatch at all (or very little)..

> Care to share an example of a change which is triggereing so we can
> better target the exception.

Basically any file in include/trace/event/ will trigger the blacklist
(listed in the perl code along with the errors that are filtered out)..

In include/trace/events/ext4.h for example the following code,

TRACE_EVENT(ext4_free_inode,
        TP_PROTO(struct inode *inode),

        TP_ARGS(inode),

        TP_STRUCT__entry(
                __field(        dev_t,  dev                     )
                __field(        ino_t,  ino                     )
                __field(        umode_t, mode                   )
                __field(        uid_t,  uid                     )
                __field(        gid_t,  gid                     )
                __field(        blkcnt_t, blocks                )
        ),

        TP_fast_assign(
                __entry->dev    = inode->i_sb->s_dev;
                __entry->ino    = inode->i_ino;
                __entry->mode   = inode->i_mode;
                __entry->uid    = inode->i_uid;
                __entry->gid    = inode->i_gid;
                __entry->blocks = inode->i_blocks;
        ),

        TP_printk("dev %s ino %lu mode %d uid %u gid %u blocks %llu",
                  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
                  __entry->mode, __entry->uid, __entry->gid,
                  (unsigned long long) __entry->blocks)
);



Daniel

