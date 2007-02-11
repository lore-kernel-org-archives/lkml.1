Return-Path: <linux-kernel-owner+w=401wt.eu-S1750750AbXBKUea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750750AbXBKUea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 15:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbXBKUea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 15:34:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59437 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbXBKUe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 15:34:29 -0500
Date: Sun, 11 Feb 2007 20:34:26 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, Alexey Dobriyan <adobriyan@openvz.org>,
       linux-kernel@vger.kernel.org, duncan.sands@math.u-psud.fr
Subject: Re: [PATCH v4] Fix rmmod/read/write races in /proc entries
Message-ID: <20070211203426.GB4095@ftp.linux.org.uk>
References: <20070208132012.GA6041@localhost.sw.ru> <20070209010037.7f4393c5.akpm@linux-foundation.org> <20070211202330.GA24509@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070211202330.GA24509@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Does it pass everyone's bullshit detectors?
 
Nice, but incomplete.  What we need to add is
	* procfs-specific file_operations shared by all regular files
on procfs.  Stuff in there would call methods from pde->proc_fops,
after having done the same kind of exclusion you are currently doing
in proc_file_read(), et.al.
	* always set ->f_op of regular files on procfs to that sucker.
Don't reset it to NULL during removal.
	* now that exclusion is done in wrappers, no need to do it in
proc_file_read().

That'll solve the rest of issues.  Eventually we might want to divorce
->proc_fops from file_operations (and trim it down), but that's a separate
story.
