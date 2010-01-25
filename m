Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802Ab0AYTYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0AYTYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 14:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783Ab0AYTYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 14:24:43 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33719 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab0AYTYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:24:43 -0500
Subject: Re: [RFC PATCH 1/2] Fix 1 untangling ima mess, part 2 with counters
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       "Serge E. Hallyn" <serue@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20100123230735.GW19799@ZenIV.linux.org.uk>
References: <cover.1264018123.git.zohar@linux.vnet.ibm.com>
	 <4ad974923eae7a8f52be0786a630b6c64bee9d32.1264018123.git.zohar@linux.vnet.ibm.com>
	 <20100123230735.GW19799@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 25 Jan 2010 14:24:37 -0500
Message-Id: <1264447477.3696.30.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-23 at 23:07 +0000, Al Viro wrote:
> On Wed, Jan 20, 2010 at 03:35:40PM -0500, Mimi Zohar wrote:
> > The "Untangling ima mess, part 2 with counters" patch messed
> > up the counters.  Based on conversations with Al Viro, this patch
> > streamlines ima_path_check() by removing the counter maintaince.
> > The counters are now updated independently, from measuring the file,
> > in __dentry_open() and alloc_file() by calling ima_counts_get().
> > ima_path_check() is called from nfsd and do_filp_open().
> > 
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > ---
> >  fs/namei.c                        |    4 +-
> >  include/linux/ima.h               |    4 +-
> >  security/integrity/ima/ima_main.c |  234 ++++++++++++++-----------------------
> 
> Um...
> 	a) where's the nfsd part?
> 	b) will that work if we open file with O_WRONLY?

Files opened O_WRONLY are not measured.

> nfsd side of things is non-trivial.  Note that you have that thing called
> an awful lot; nfsd_permission() is called by fh_verify().  For which
> operations do you really want it to happen?  Should it just migrate to
> nfsd_open()?

The IMA counters are updated in alloc_file() and __dentry_open().
__dentry_open() is called from a couple of places:
lookup_instantiate_filp(), nameidata_to_filp() and dentry_open.  Of
these calls, files are only being measured in the nameidata_to_filp()
path.  So yes, the current ima_path_check() needs to be moved to after
the dentry_open() in nfsd_open(), and also added after each of the other
dentry_open() and lookup_instantiate_filp() calls.  Otherwise the
counters will be correct, but the files will not be measured.

Eric's proposed patches had two calls to ima_path_check().  Was sure
looking forward to not having to add ima_path_check() calls all over.

Mimi

