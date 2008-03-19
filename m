Return-Path: <linux-kernel-owner+w=401wt.eu-S965888AbYCSVTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965888AbYCSVTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbYCSUAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:00:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48863 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762004AbYCSUAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:00:00 -0400
Date: Wed, 19 Mar 2008 12:41:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] vfs: mountinfo show dominating group id
Message-ID: <20080319124155.GN10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu> <20080313212737.053993902@szeredi.hu> <20080319113704.GJ10722@ZenIV.linux.org.uk> <E1Jbx0r-00027l-0q@pomaz-ex.szeredi.hu> <E1JbxGg-0002Ec-SD@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JbxGg-0002Ec-SD@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 01:19:42PM +0100, Miklos Szeredi wrote:
> > So maybe some alternative, multi line format would be better?
> > 
> > MountID: 99
> > ParentID: 88
> > DevID: 0:34
> > Type: foofs
> > Source: /dev/foo
> > Root: /
> > MountPoint: /mnt/foo
> > MountOpts: rw,noatime
> > Opts: rw,errors=continue
> > Propagation: shared:42
> 
> Which still doesn't fully solve the problem, since ->show_options()
> can also spew newlines + MountID:.  Oh well.

a) ban newlines in ->show_options(); that's a requirement that is easy
to formulate and understand, so it has a chance to survive the contact
with reality.

b) the order is all wrong - *everything* that depends on fs type should
be after fs type and everything else should be prior to it.  That way
you don't need to know what the hell does this fs type spew in order to
parse type-independent information.  In particular, "source" (BTW, why
do you capitalize those?) certainly has no business being in front of
fs type; as the matter of fact, I'm not at all sure that we _want_ it
separated from the rest of type-dependent options.  The fact that mount(2)
gets it in a separate argument is a historical accident...

c) since you are tagging the fields anyway, why do you need newlines?
Moreover, you don't really need to tag everything - there's a well-defined
beginning and optional fields between it and (type+rest) are the only
things that needs to be tagged...  BTW, why bother with Propagation: part
and gluing shared:... with slave:... into a single field?  Separate them
with whitespace - you have recognizable prefixes right there.
