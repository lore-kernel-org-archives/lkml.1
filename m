Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab0BTTLF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 14:11:05 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60514 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab0BTTLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 14:11:00 -0500
Message-ID: <4B8033B9.7070705@canonical.com>
Date: Sat, 20 Feb 2010 11:10:49 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: John Johansen <john.johansen@canonical.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 01/12] Miscellaneous functions and defines needed by AppArmor,
 including the base path resolution routines.
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com> <1266572188-26529-2-git-send-email-john.johansen@canonical.com> <20100219110320.GL30031@ZenIV.linux.org.uk> <4B7FD2F0.6090602@canonical.com> <4B801AF6.20003@canonical.com>
In-Reply-To: <4B801AF6.20003@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Johansen wrote:
> John Johansen wrote:
>> Al Viro wrote:
>>> On Fri, Feb 19, 2010 at 01:36:17AM -0800, john.johansen@canonical.com wrote:
>>>
>>>> +static int d_namespace_path(struct path *path, char *buf, int buflen,
>>>> +			    char **name, int flags)
>>>> +{
>>>> +	struct path root, tmp, ns_root = { };
>>>> +	char *res;
>>>> +	int deleted, connected;
>>>> +	int error = 0;
>>>> +
>>>> +	read_lock(&current->fs->lock);
>>>> +	root = current->fs->root;
>>>> +	/* released below */
>>>> +	path_get(&root);
>>>> +	read_unlock(&current->fs->lock);
>>>> +
>>>> +	spin_lock(&vfsmount_lock);
>>>> +	if (root.mnt && root.mnt->mnt_ns)
>>>> +		/* released below */
>>>> +		ns_root.mnt = mntget(root.mnt->mnt_ns->root);
>>>> +	if (ns_root.mnt)
>>>> +		/* released below */
>>>> +		ns_root.dentry = dget(ns_root.mnt->mnt_root);
>>>> +	spin_unlock(&vfsmount_lock);
>>> Junk.  You might as well leave ns_root {NULL, NULL} instead of that crap.
>>>
>> Right, though the ns_root.mnt and ns_root.dentry are needed below to detect
>> disconnected paths.
>>
> Well no, actually I don't need it.  After looking at this again,
> If struct path tmp is unmodified we hit our expected root.

Sigh so much for "brillant" ideas after a few hours of sleep.  If tmp is modified
we only know that we made it to global_root:   We still need to distinguish lazy
unmount, ideally we would do this in __d_path instead of here.  I'll resurrect our
old patches doing just that and post them out for comment.
