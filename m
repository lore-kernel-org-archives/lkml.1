Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYLAUy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYLAUy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 15:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYLAUys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 15:54:48 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49778 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbYLAUyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 15:54:47 -0500
Subject: Re: [RFC v10][PATCH 09/13] Restore open file descriprtors
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Linus Torvalds <torvalds@osdl.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <49344C11.6090204@cs.columbia.edu>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>
	 <1227747884-14150-10-git-send-email-orenl@cs.columbia.edu>
	 <20081128112745.GR28946@ZenIV.linux.org.uk>
	 <1228159324.2971.74.camel@nimitz>  <49344C11.6090204@cs.columbia.edu>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 12:54:33 -0800
Message-Id: <1228164873.2971.95.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-01 at 15:41 -0500, Oren Laadan wrote:
> >>> +   fd = cr_attach_file(file);      /* no need to cleanup 'file' below */
> >>> +   if (fd < 0) {
> >>> +           filp_close(file, NULL);
> >>> +           ret = fd;
> >>> +           goto out;
> >>> +   }
> >>> +
> >>> +   /* register new <objref, file> tuple in hash table */
> >>> +   ret = cr_obj_add_ref(ctx, file, parent, CR_OBJ_FILE, 0);
> >>> +   if (ret < 0)
> >>> +           goto out;
> >> Who said that file still exists at that point?
> 
> Correct. This call should move higher up befor ethe call to cr_attach_file()

Is that sufficient?  It seems like we're depending on the fd's reference
to the 'struct file' to keep it valid in the hash.  If something happens
to the fd (like the other thread messing with it) the 'struct file' can
still go away.

Shouldn't we do another get_file() for the hash's reference?

-- Dave

