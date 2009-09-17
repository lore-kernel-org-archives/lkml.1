Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbZIQWTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbZIQWTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbZIQWTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:19:36 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:19339 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZIQWTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:19:36 -0400
Date: Thu, 17 Sep 2009 18:19:23 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: jack@suse.cz, tytso@mit.edu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC] Ext3 data=guarded
Message-ID: <20090917221923.GB21798@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Jamie Lokier <jamie@shareable.org>, jack@suse.cz, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1252422595-4554-1-git-send-email-chris.mason@oracle.com>
 <20090917215309.GD10599@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917215309.GD10599@shareable.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4AB2B5ED.00C4:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 10:53:09PM +0100, Jamie Lokier wrote:
> Chris Mason wrote:
> > The main difference from data=ordered is that data=guarded only updates
> > the on disk i_size after all of the data blocks are on disk.  This allows
> > us to avoid flushing all the data pages down to disk with every commit.
> 
> I'm a bit confused, because I thought that was already guaranteed by
> ext3 data=ordered, due to the following mail:

Well, in data=ordered mode, we update the on disk i_size immediately.
This means that when the current transaction commits, the on disk i_size
reflects everything that has been written from file_write.

In order to avoid exposing stale data in data=ordered, we must force all
the dirty data down to disk before the transaction commits.

In data=guarded mode, we update the on disk i_size after all the data IO
is complete.  This may happen in a later transaction than the original
file write, but it allows us to avoid exposing stale data because the
i_size on disk is never bumped up until the data isn't stale anymore.

In data=guarded mode, the orphan list is used to make sure that all of
the metadata related to bytes that exist past the on disk i_size is
properly dealt with if we crash before the on disk i_size is updated.

data=guarded makes no ordering promises about overwriting existing
blocks inside of i_size.

-chris
