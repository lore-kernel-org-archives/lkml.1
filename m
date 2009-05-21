Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZEUJq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZEUJq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbZEUJqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:46:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59927 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZEUJqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:46:48 -0400
Date: Thu, 21 May 2009 10:46:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm] fsnotify: don't slow everything down
Message-ID: <20090521094613.GT8633@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.0905171445290.18657@blonde.anvils> <1242574698.5212.35.camel@dhcp231-142.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242574698.5212.35.camel@dhcp231-142.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 11:38:17AM -0400, Eric Paris wrote:

> If people feel strongly I can come up with a system to reuse the inotify
> flag now....  I planned on dropping the old inotify flag in a couple
> releases when I finally evict inotify entirely, it would be a
> performance hit, but I have a feeling a minimal one.  In any case, when
> I push these patches along I'll probably move the new flag rather than
> _COOKIE since long term they won't be 'together'
> 
> Acked-by: Eric Paris <eparis@redhat.com>

OK...  After the last round of review (going by what's in mmotm):
	* it got much better; at least the lifetime rules for generic
structures are sane now and locking seems to be OK.
	* fsnotify() has too many arguments ;-/  It might actually be
worth splitting into for-inode/for-file/etc. cases, and to hell with
code duplication.  Note that adding for-dentry variant would take care
of the file_name argument, so in any case it might be a good idea to
add FSNOTIFY_EVENT_FROM_DENTRY, turning itself into ..._INODE and getting
d_name, even if you don't go for splitting that sucker.
	In any case, that's a separate patch and it might not be an
improvement.
	* inotify should_send_event - no need to bother with refcounting,
AFAICS, since the decision can be made before dropping i_lock.  BTW,
bool x; ..... x = foo ? true : false;  is spelled x = foo.  That's what
conversion to _Bool does, by definition, and kernel-side bool *is* _Bool.
	* inotify_handle_event() - um... why will ->wd we'd got from the
event we'd found and dropped survive through a bunch of blocking allocations?
With no locks held...
	* #10 and #11 might be worth merging.  Sure, you have them prior to
inotify conversion, but...
	* the stuff added in #9 looks odd.  Your queue is a FIFO; what happens
if I run into overflow, add overflow event into the end, remove some, drive
q_len down to something tolerable, then add more, then run into overflow again?
AFAICS, you get the same event queued twice for the same group, in the same
queue, with different priv.  Then you get ->free_event_priv() called on
flush_notify() for it.  Granted, that'll happen twice, so natural use of
get_priv_from_event() in the method instance will allow to DTRT, but that's
	a) asking for trouble
	b) at least needs to be commented.
Why not pass the damn pointer to priv to the method instead?  I'm not sure
where you are going with that stuff, but it would seem to make more sense...
AFAICS, the only current user (inotify) is OK *and* you are probably going
to add the next user yourself, so it can be changed later, but...

Overall: the only serious question I have right now is about ->wd in
inotify_handle_event().  Modulo that it's OK for -next; modulo that
and testing for regressions (*including* overhead ones)... I can live
with that going into mainline, provided that you are going to maintain
fs/notify/ afterwards.
