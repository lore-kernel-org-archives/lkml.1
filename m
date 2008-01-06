Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYAFCzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYAFCzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 21:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYAFCyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 21:54:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:19531 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbYAFCyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 21:54:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=aoVW/BY7mxCaRk7gx4yq9XjGyJd3Q4KXbvQb+DDQKIPNHDDYaV3YSRi5Y7Lp3da+UY1lm8jj5dDx/lV4HgXqXB6FjN+wkqPpjmyvlqLXuBAqjmfV/bkBVvzf8NqtHwcsod9aT+NfjDJviBJxnyCY698hcOoQf/y8cbd+hp1SaDE=
Message-ID: <478042F3.7010002@gmail.com>
Date: Sun, 06 Jan 2008 11:54:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Gabor Gombas <gombasg@sztaki.hu>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>, ebiederm@xmission.com
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080105075039.GF27894@ZenIV.linux.org.uk> <477F9481.2040505@gmail.com> <20080105194510.GK27894@ZenIV.linux.org.uk> <478037F8.8020103@gmail.com> <20080106021826.GR27894@ZenIV.linux.org.uk>
In-Reply-To: <20080106021826.GR27894@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Al Viro.

Al Viro wrote:
> On Sun, Jan 06, 2008 at 11:07:52AM +0900, Tejun Heo wrote:
> 
>> Right, I haven't thought about that.  When sysfs_get_dentry() is called,
>> @sd is always valid so unless there was existing negative dentry, lookup
>> is guaranteed to return positive dentry, but by populating dcache with
>> negative dentry before a node is created, things can go wrong.  I don't
>> think that's what's going on here tho.  If that was the case, the
>> while() loop looking up the next sd to lookup (@cur) should have blown
>> up as negative dentry will have NULL d_fsdata which doesn't match any sd.
> 
> No.  What happens if sd gets unlinked while we are on the way to
> sysfs_get_dentry() and so does its parent?

That means sysfs_remove_dir() is called on parent while other operations
are in progress on children, right?  sysfs has never allowed such things
&& AFAIK no one does that.  It's somewhat implied in the interface (such
as recursive removing) but I fully agree it's problematic.  Things like
these are why I think we need to unify/simplify locking as I wrote
previously.

> The parent is off the
> sibling list, we get negative dentry from lookup.  It's not hashed,
> so won't stick around in dcache (which is apparently what you are
> thinking about).  However, _THIS_ lookup has returned you a dentry
> with NULL ->d_inode and you are well and truly buggered.

So, the assumption is that while @sd is held and being operated on its
ancestry can never change except for rename and move and those are
protected with sysfs_rename_mutex.

I agree that the locking is awkward but sysfs's internal implementation
has completely changed over last six or so months and the conversion
still isn't complete.  It isn't pretty at all but is at least
understandable now, IMHO.  :-)

The last pending change is separating out kobject from sysfs and
simplifying locking.  I had some disagreement with Greg about the future
of kobject and then there was tsunami of ATA bugs because most major
distros converted to libata from IDE in the second half of the last year
and I'm still buried under it.  I'll get back to sysfs once these ATA
bugs subside a bit.

Thanks.

-- 
tejun
