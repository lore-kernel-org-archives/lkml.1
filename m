Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbYDXRze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbYDXRze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYDXRzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:55:24 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56035 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbYDXRzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:55:23 -0400
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1Jp3Vz-0004FH-Ih@pomaz-ex.szeredi.hu>
References: <20080424113950.818688067@szeredi.hu>
	 <20080424124245.GC15214@ZenIV.linux.org.uk>
	 <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu>
	 <20080424134826.GD15214@ZenIV.linux.org.uk>
	 <20080424140000.GE15214@ZenIV.linux.org.uk>
	 <E1Jp2Fo-0003sr-BX@pomaz-ex.szeredi.hu>
	 <20080424143537.GG15214@ZenIV.linux.org.uk>
	 <E1Jp2ey-0003zd-TL@pomaz-ex.szeredi.hu>
	 <20080424144815.GI15214@ZenIV.linux.org.uk>
	 <E1Jp2tc-00044i-6k@pomaz-ex.szeredi.hu>
	 <20080424152129.GK15214@ZenIV.linux.org.uk>
	 <E1Jp3Vz-0004FH-Ih@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 10:55:17 -0700
Message-Id: <1209059717.12718.32.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-24 at 17:37 +0200, Miklos Szeredi wrote:
> Why are those so important?  Yes, if we have multiple vfs_() calls,
> surround them with an extra want/drop pair.  We do already do multiple
> overlapping want/drop pairs with O_TRUNC and O_CREAT (AFAIR).

The one that I remember is the pair that we take for O_CREAT and the
nameidata_to_filp() in do_filp_open() that we do on it after the
creation and hold while the file is open.

The only reason for this one is that we want to shut down a potential
race that would allow the file to be created, then still return a -EROFS
because someone did a r/w->r/o transition between the create an the
nameidata_to_filp().

We could pass some information into nameidata_to_filp()->__dentry_open()
telling it that we already have a write and it doesn't need to take one,
but I think having the two nested writes is cleaner.

Is that the case you're thinking of?

-- Dave

