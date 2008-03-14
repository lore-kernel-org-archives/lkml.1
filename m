Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbYCNRHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbYCNRHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 13:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYCNRG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 13:06:59 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:17574 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbYCNRG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 13:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xqwJojDb6ztmmGnw0nRHhN28ENiY9Hvprmi1+sQgZGACrUwZ1ewe9Jj4D0ZYq/jrR9WfnJS/7RjwHwmqN0Q5tMIXq6/ZXDiHDxb+mxGyE2H5nxDMXy8SJ6PPQcQTl6/M/m8R143331dToRy7bP7V50vuZo5piSTXIWw1X5sIXRI=
Subject: Re: [PATCH 01/10] Add macros similar to min/max/min_t/max_t.
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47DAAC9E.1060001@oracle.com>
References: <1205471926.19712.12.camel@brick>
	 <20080314093451.cd3e644c.randy.dunlap@oracle.com>
	 <1205513171.27712.1.camel@brick>  <47DAAC9E.1060001@oracle.com>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 10:06:48 -0700
Message-Id: <1205514408.27712.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-14 at 09:49 -0700, Randy Dunlap wrote:
> Harvey Harrison wrote:
> > On Fri, 2008-03-14 at 09:34 -0700, Randy Dunlap wrote:
> >> On Thu, 13 Mar 2008 22:18:45 -0700 Harvey Harrison wrote:
> > 
> >> Where is some blurb/comment about what "clamp" means/does?
> >> min/max are well understood, but clamp?  Is that a shop tool?
> >> I think I have a few out in my garage.
> > Sure, I'll do that..does kernel-doc actually work for macros?
> 
> Yes, it does.
> 

OK, here's what I've come up with:

/**
 * clamp - return a value clamped to a given range with strict typechecking
 * @val: current value
 * @min: minimum allowable value
 * @max: maximum allowable value
 *
 * This macro does strict typechecking of min/max to make sure they of the
 * same type as val.  See the unnecessary pointer comparisons.
 */
#define clamp(val, min, max) ({			\
	typeof(val) __val = (val);		\
	typeof(min) __min = (min);		\
	typeof(max) __max = (max);		\
	(void) (&__val == &__min);		\
	(void) (&__val == &__max);		\
	__val = __val < __min ? __min: __val;	\
	__val > __max ? __max: __val; })

/**
 * clamp_t - return a value clamped to a given range using a given type
 * @type: the type of variable to use
 * @val: current value
 * @min: minimum allowable value
 * @max: maximum allowable value
 *
 * This macro does no typechecking and uses temporary variables of type
 * 'type' to make all the comparisons.
 */
#define clamp_t(type, val, min, max) ({		\
	type __val = (val);			\
	type __min = (min);			\
	type __max = (max);			\
	__val = __val < __min ? __min: __val;	\
	__val > __max ? __max: __val; })

/**
 * clamp_val - return a value clamped to a given range using val's type
 * @val: current value
 * @min: minimum allowable value
 * @max: maximum allowable value
 *
 * This macro does no typechecking and uses temporary variables of whatever
 * type the input argument 'val' is.  This is useful when val is an unisgned
 * type and min and max are literals that will otherwise be assigned a signed
 * integer type.
 */
#define clamp_val(val, min, max) ({		\
	typeof(val) __val = (val);		\
	typeof(val) __min = (min);		\
	typeof(val) __max = (max);		\
	__val = __val < __min ? __min: __val;	\
	__val > __max ? __max: __val; })

Comments?  Please let me know if I got the kerneldoc format right.

Harvey

