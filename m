Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbXFTNF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbXFTNF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 09:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbXFTNFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 09:05:13 -0400
Received: from main.gmane.org ([80.91.229.2]:37500 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756732AbXFTNFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 09:05:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC PATCH 1/4] Union mount documentation.
Date: Wed, 20 Jun 2007 12:56:58 +0000 (UTC)
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
Message-ID: <f5b86q$f4g$2@sea.gmane.org>
References: <20070620055050.GB4267@in.ibm.com>
	<20070620055157.GC4267@in.ibm.com>
	<1182319191.2700.9.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: charybdis-ext.suse.de
User-Agent: pan 0.119 (Karma Hunters)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 22:59:51 -0700, Arjan van de Ven wrote:

> user does on FS A: 
> mkdir  /mnt/A/somedir
> touch /mnt/A/somedir/somefile
> 
> and then 2 things happen in parallel
> 1) touch /mnt/B/somefile
> 2) mv /mnt/union/somedir /mnt/union/somefile
> 
> since the underlying FS for 2) is FS A... how will this work out locking
> wise? Will the VS lock the union directory only? Or will this operate
> only on the underlying FS? How is dcache consistency guaranteed for
> scenarios like this?

Ok, with Christophs help I guess I know now what the question is :)

touch /mnt/B/somefile is doing a lookup in "B" for "somefile". Therefore it
locks B->i_mutex for that. When it gets a negative dentry it creates the
file.

mv /mnt/union/somedir /mnt/union/somefile is doing a lookup in "union" for
"somefile". Therefore it first locks the i_mutex of the topmost directory
in the union of "/mnt/union" (which happens to be "B"). When it gets a
negative dentry it than follows the union down to the next layer (with the
topmost directory still locked). Lookup is repeated until a filled dentry
is found or the topmost dentry negative dentry is used as a target for the
move. Thats it.

Did that answer your question?

Cheers,
Jan

