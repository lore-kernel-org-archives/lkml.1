Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597Ab0ATUgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0ATUgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998Ab0ATUgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:36:11 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:48271 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab0ATUf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:35:58 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Eric Paris <eparis@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       "Serge E. Hallyn" <serue@linux.vnet.ibm.com>
Subject: [RFC PATCH 0/2] Fix untangling ima mess, part 2 with counters
Date: Wed, 20 Jan 2010 15:35:39 -0500
Message-Id: <cover.1264018123.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "Untangling ima mess, part 2 with counters" patch not
only messed up the counters, but also doesn't measure files
which should be measured. The "Untangling ima mess ..."
patchset, applied some of Eric's patches, but not all, leaving
inodes allocated before late_initcall() not allocated/measured.
(8262bb85da ima: initialize ima before inodes can be allocated)

Up to now, measuring files and updating the IMA open/read/write
counters associated with the file were done at the same time
in ima_path_check().  An imbalanced counter was an indication
that the file hadn't been measured. Each case needed to be
inspected, resulting in adding either a new ima_counts_get()
or ima_path_check() call (e.g. nfsd, ecryptfs, openAFS).

This patchset separates incrementing the counters from measuring
the file.  However, the underlying assumption is that all regular
files are opened via do_filp_open(). Is this assumption correct or,
by incrementing the file counters separately, have we inadvertently
hidden the fact that a file wasn't measured?

Mimi
