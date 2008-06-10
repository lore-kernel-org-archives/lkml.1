Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbYFJVV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbYFJVV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYFJVVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:21:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:43531 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbYFJVVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:21:16 -0400
Date: Tue, 10 Jun 2008 23:21:58 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add diffconfig utility
Message-ID: <20080610212158.GB23855@uranus.ravnborg.org>
References: <484ED902.9040000@am.sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484ED902.9040000@am.sony.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 12:41:54PM -0700, Tim Bird wrote:
> diffconfig is a simple utility for comparing two .config files.
> Using standard diff to compare .config files often includes
> extraneous and distracting information.  This utility produces
> sorted output with only the changes in configuration values
> between the two files.
> 
> I have found this handy for use in testing to
> detect when option dependencies unexpectedly affect
> other options.
> 
> To use, apply the patch and 'chmod a+x scripts/diffconfig'
> 
> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> 
>  diffconfig |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 90 insertions(+)
> 
> --- linux-2.6.24.orig/scripts/diffconfig	1969-12-31 16:00:00.000000000 -0800
> +++ test-linux/scripts/diffconfig	2008-06-10 12:11:14.000000000 -0700
> @@ -0,0 +1,90 @@
> +#!/usr/bin/python
> +#
> +# diffconfig - a tool to compare .config files.
> +#
> +# originally written in 2006 by Matt Mackall
> +#  (at least, this was in his bloatwatch source code)
> +#
> +# diffconfig is a simple utility for comparing two .config files.
> +# Using standard diff to compare .config files often includes
> +# extraneous and distracting information.  This utility produces
> +# sorted output with only the changes in configuration values
> +# between the two files.
> +#
> +# Added and removed items are shown with a leading plus or minus,
> +# respectively.  Changed items show the old and new values on a
> +# single line.
> +#
> +# Example usage:
> +# $ diffconfig .config config-test-nfs-off
> +# -LOCKD  y
> +# -LOCKD_V4  y
> +# -NFS_COMMON  y
> +# -NFS_DIRECTIO  n
> +# -NFS_V3  y
> +# -NFS_V3_ACL  n
> +# -NFS_V4  n
> +# -ROOT_NFS  y
> +# -RPCSEC_GSS_KRB5  n
> +# -RPCSEC_GSS_SPKM3  n
> +# -SUNRPC  y
> +# -SUNRPC_BIND34  n
> +#  NFS_FS  y -> n
> +
> +import sys, os
> +
> +if len(sys.argv) < 3:
> +	print "Usage: diffconfig <config1> <config2>"
> +	sys.exit(0)

I know this is unix style to be very short in usage - but then they 
have man pages.
Could we add a bit more from the nice description above to usage?


> +
> +# returns a dictionary of name/value pairs for config items in the file
> +def readconfig(config_file):
> +    d = {}
> +    for line in config_file:
> +        line = line[:-1]
> +        if line[:7] == "CONFIG_":
> +            name, val = line[7:].split("=", 1)
> +            d[name] = val
> +        if line[-11:] == " is not set":
> +            d[line[9:-11]] = "n"
> +    return d
> +
> +a = readconfig(file(sys.argv[1]))
> +b = readconfig(file(sys.argv[2]))
> +
> +# print items in a but not b (accumulate, sort and print)
> +old = []
> +for config in a:
> +    if config not in b:
> +        old.append(config)
> +
> +old.sort()
> +
> +for config in old:
> +    print "-%s  %s" % (config, a[config])
> +    del a[config]
> +
> +# print items that changed (accumulate, sort, and print)
> +changed = []
> +for config in a:
> +    if a[config] != b[config]:
> +        changed.append(config)
> +    else:
> +        del b[config]
> +
> +changed.sort()
> +
> +for config in changed:
> +    print " %s  %s -> %s" % (config, a[config], b[config])
> +    del b[config]
> +
> +# now print items in b but not in a
> +
> +# the items from b that were in a (either the same or that changed) were removed
> +# the only items left were not in a
> +new = b.keys()
> +
> +new.sort()
> +
> +for config in new:
> +    print "+%s  %s" % (config, b[config])

No feedback on the implmentation - I do not speak phython.

	Sam
