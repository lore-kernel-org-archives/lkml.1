Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbZBWHhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbZBWHhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZBWHh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:37:27 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:39465 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbZBWHh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:37:26 -0500
From: hooanon05@yahoo.co.jp
Subject: [RFC 6/8] Aufs2: fmode_exec
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <7558.1235374266@jrobl>
References: <7558.1235374266@jrobl>
Date: Mon, 23 Feb 2009 16:37:24 +0900
Message-ID: <7816.1235374644@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This is my second trial to ask incorporating aufs into mainline.


FMODE_EXEC and deny_write()
----------------------------------------------------------------------
Generally Unix prevents an executing file from writing its filedata.
In linux it is implemented by deny_write() and allow_write().
When a file is executed by exec() family, open_exec() (and sys_uselib())
they opens the file and calls deny_write(). If the file is aufs's virtual
one, it has no meaning. The file which deny_write() is really necessary
is the file on a branch. But the FMODE_EXEC flag is not passed to
->open() operation. So aufs adopt a dirty trick.

- in order to get FMODE_EXEC, aufs ->lookup() and ->d_revalidate() set
  nd->intent.open.file->private_data to nd->intent.open.flags temporary.
- in aufs ->open(), when FMODE_EXEC is set in file->private_data, it
  calls deny_write() for the file on a branch.
- when the aufs file is released, allow_write() for the file on a branch
  is called.
