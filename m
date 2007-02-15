Return-Path: <linux-kernel-owner+w=401wt.eu-S964873AbXBOCns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873AbXBOCns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 21:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964875AbXBOCns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 21:43:48 -0500
Received: from mx1.suse.de ([195.135.220.2]:60617 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964873AbXBOCnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 21:43:47 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Fix d_path for lazy unmounts
Date: Wed, 14 Feb 2007 18:43:49 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Tony Jones <tonyj@suse.de>
References: <200702021923.02491.agruen@suse.de> <17862.30489.694079.138765@notabene.brown>
In-Reply-To: <17862.30489.694079.138765@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141843.49668.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 February 2007 16:15, Neil Brown wrote:
> The behaviour in the face of a lazy unmount should be clarified in
> this comment.

Done.

> If sys_getcwd is called on a directory that is no longer
> connected to the root, it isn't clear to me that it should return
> without an error.
> Without your patch it can return garbage which is clearly wrong.
> With you patch it will return a relative path name, which is also
> wrong (it isn't a valid path that leads to the current working directory).

Right, it should return -ENOENT instead in that case. Fixed as well.

> I would suggest that 'fail_deleted' be (e.g.) changed to
> 'fail_condition' where two conditions are defined
> #define DPATH_FAIL_DELETED 1
> #define DPATH_FAIL_DISCONNECTED 2

The much cleaner interface is to check if the path returned starts with a 
slash. If it doesn't, we know the path is bad as far as sys_getcwd() is 
concerned. We will construct the partial path in __d_path before figuring out 
that the path is disconnected, so no performance penalty, either.

> In reality, you are comparing "buflen < namelen+1" but spelling it as
> "buflen <= namelen".  I would prefer the full spelling with least room
> for confusion.

I'm fine either way.

> Maybe:
> > +		buflen -= namelen + 1;
> > +		buffer -= namelen + 1;
> > +		memcpy(buffer+1, dentry->d_name.name, namelen);
> > +		*buffer = '/';

That's better, yes.

Thanks,
Andreas
