Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab0BVC1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 21:27:43 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:65445 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab0BVC1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 21:27:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fdqPGPYiUK6FezxqlQ/YbrZ1K1m6Z1szwuRKXSIszCn2YHobbUFrFXBCVu5JzJO/Kr
         S2xjlS1CJjMVRCqHJAZh5DzEFvmuHI8ThtXS5Afd93vrpNYiwgMowLdKqkui/hqLoIC/
         N62hdlf0fh9GLjNFXBom4UZmYFKrhXungJqQs=
Date: Mon, 22 Feb 2010 03:27:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: Re: [PATCH 06/12] perf trace/scripting: add Python scripting engine
Message-ID: <20100222022735.GC8791@nowhere>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com> <1264580883-15324-7-git-send-email-tzanussi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264580883-15324-7-git-send-email-tzanussi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 02:27:57AM -0600, Tom Zanussi wrote:
> +static void define_value(enum print_arg_type field_type,
> +			 const char *ev_name,
> +			 const char *field_name,
> +			 const char *field_value,
> +			 const char *field_str)
> +{
> +	const char *handler_name = "define_flag_value";
> +	PyObject *handler, *t, *retval;
> +	unsigned long long value;
> +	unsigned n = 0;
> +
> +	if (field_type == PRINT_SYMBOL)
> +		handler_name = "define_symbolic_value";
> +
> +	t = PyTuple_New(MAX_FIELDS);
> +	if (!t)
> +		Py_FatalError("couldn't create Python tuple");
> +
> +	value = eval_flag(field_value);
> +
> +	PyTuple_SetItem(t, n++, PyString_FromString(ev_name));
> +	PyTuple_SetItem(t, n++, PyString_FromString(field_name));
> +	PyTuple_SetItem(t, n++, PyInt_FromLong(value));
> +	PyTuple_SetItem(t, n++, PyString_FromString(field_str));
> +
> +	if (_PyTuple_Resize(&t, n) == -1)
> +		Py_FatalError("error resizing Python tuple");



Why are creating a tuple of 64 fields while you are always using
4?



> +
> +	handler = PyDict_GetItemString(main_dict, handler_name);
> +	if (handler && PyCallable_Check(handler)) {
> +		retval = PyObject_CallObject(handler, t);
> +		if (retval == NULL)
> +			handler_call_die(handler_name);
> +	}
> +
> +	Py_DECREF(t);
> +}
> +
> +

[...]

> +static void define_field(enum print_arg_type field_type,
> +			 const char *ev_name,
> +			 const char *field_name,
> +			 const char *delim)
> +{
> +	const char *handler_name = "define_flag_field";
> +	PyObject *handler, *t, *retval;
> +	unsigned n = 0;
> +
> +	if (field_type == PRINT_SYMBOL)
> +		handler_name = "define_symbolic_field";
> +
> +	t = PyTuple_New(MAX_FIELDS);
> +	if (!t)
> +		Py_FatalError("couldn't create Python tuple");
> +
> +	PyTuple_SetItem(t, n++, PyString_FromString(ev_name));
> +	PyTuple_SetItem(t, n++, PyString_FromString(field_name));
> +	if (field_type == PRINT_FLAGS)
> +		PyTuple_SetItem(t, n++, PyString_FromString(delim));
> +
> +	if (_PyTuple_Resize(&t, n) == -1)
> +		Py_FatalError("error resizing Python tuple");



Same here (except you may or may not have a PRINT_FLAGS type).

This is about neats though. The patch looks pretty nice.

